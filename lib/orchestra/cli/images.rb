require "open3"
require "pathname"
require "benchmark"

class Orchestra::Cli::Images < Orchestra::Base
  desc "build", "Build and push a Docker image"
  method_option :git_url,         type: :string, required: true
  method_option :commit_id,       type: :string, required: true
  method_option :cache_bucket,    type: :string, required: true
  method_option :cache_region,    type: :string, required: true
  method_option :image_uri,       type: :string, required: true
  method_option :dockerfile,      type: :string, required: true
  method_option :build_context,   type: :string, required: true
  def build
    status = 1
    # Disable output buffering, otherwise exec prevents some of the puts to be visible
    $stdout.sync = true

    puts "Checking out commit #{options.commit_id}..."

    checkout_time = Benchmark.realtime do
      output, status =
        Open3.capture2e "envirobly-git-checkout-commit", git_checkout_path.to_s, options.git_url, options.commit_id

      puts output
    end

    puts "Checkout finished in #{checkout_time.to_i}s\n"

    exit 1 if status.to_i > 0

    exec *buildx_build_cmd
  end

  private
    def buildx_build_cmd
      [
        "docker", "buildx", "build",
        "--progress=plain",
        "--cache-from=type=s3,region=#{options.cache_region},bucket=#{options.cache_bucket},name=app",
        "--cache-to=type=s3,region=#{options.cache_region},bucket=#{options.cache_bucket},name=app,mode=max",
        "-t", options.image_uri, "--push",
        "-f", dockerfile_path.to_s,
        build_context.to_s
      ]
    end

    def git_checkout_path
      Pathname.new "/tmp/build"
    end

    def build_context
      git_checkout_path.join options.build_context
    end

    def dockerfile_path
      git_checkout_path.join options.dockerfile
    end
end
