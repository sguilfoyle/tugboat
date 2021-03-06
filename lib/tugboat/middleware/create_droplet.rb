module Tugboat
  module Middleware
    class CreateDroplet < Base
      def call(env)
        ocean = env["ocean"]

        say "Queueing creation of droplet '#{env["create_droplet_name"]}'...", nil, false

        env["create_droplet_region_id"] ?
            droplet_region_id = env["create_droplet_region_id"] :
            droplet_region_id = env["config"].default_region

        env["create_droplet_image_id"] ?
            droplet_image_id = env["create_droplet_image_id"] :
            droplet_image_id = env["config"].default_image

        env["create_droplet_size_id"] ?
            droplet_size_id = env["create_droplet_size_id"] :
            droplet_size_id = env["config"].default_size

        env["create_droplet_ssh_key_ids"] ?
            droplet_ssh_key_id = env["create_droplet_ssh_key_ids"] :
            droplet_ssh_key_id = env["config"].default_ssh_key

        req = ocean.droplets.create :name        => env["create_droplet_name"],
                                    :size_id     => droplet_size_id,
                                    :image_id    => droplet_image_id,
                                    :region_id   => droplet_region_id,
                                    :ssh_key_ids => droplet_ssh_key_id

        if req.status == "ERROR"
          say req.error_message, :red
          exit 1
        end

        say "done", :green

        @app.call(env)
      end
    end
  end
end

