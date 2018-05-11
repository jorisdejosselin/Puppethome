require 'facter'

# Default for non-Linux nodes
#
Facter.add(:docker_token) do
    setcode do
        nil
    end
end

# Linux
#
Facter.add(:docker_token) do
    confine :kernel  => :linux
    setcode do
        Facter::docker::Resolution.exec("/bin/bash/docker swarm join-token worker -q")
    end
end