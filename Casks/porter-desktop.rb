cask "porter-desktop" do
  arch arm: "aarch64", intel: "x86_64"

  version "2.0.0"
  sha256 arm:   "8fe318b548bd8fbc0a484f5f28edb715683807ae38ce8fa886c3a5689a98b3b5",
         intel: "e083e86dbef46112d4000f7b4b3efccc85946390d81b8877d0675c27d670e351"

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
