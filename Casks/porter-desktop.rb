cask "porter-desktop" do
  arch arm: "aarch64", intel: "x86_64"

  version "2.1.0"
  sha256 arm:   "24f5dc2082a245fdba25f47f634fcd81a438d0ef491fb57d85cee33183544675",
         intel: "493cf4ab95a2c8c9fa6170a1dbc706d7467d98c782e1290d4478f33e6de53587"

  url "https://github.com/umi-labs/porter/releases/download/v#{version}/Porter_#{version}_#{arch}.dmg"
  name "Porter"
  desc "Desktop app for Porter, Umi's site migration tool"
  homepage "https://github.com/umi-labs/porter"

  depends_on macos: ">= :big_sur"

  app "Porter.app"

  # Not notarised yet (no Apple Developer ID): clear quarantine so Gatekeeper allows it.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/Porter.app"]
  end
end
