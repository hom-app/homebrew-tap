cask "hom" do
  version "0.3.1"
  sha256 "f5a1d2bcf9a414447cc48229ae78c8e6b68569d8f000cda4b3817a9730710371"

  url "https://github.com/hom-app/releases/releases/download/v#{version}/hom-mac.dmg"
  name "hom"
  desc "Domotique qui aide à se sentir à la maison"
  homepage "https://hom-ave.pages.dev/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "hom.app"

  # L'app n'est pas encore signée par Apple : sans cela, macOS refuserait de l'ouvrir.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/hom.app"], must_succeed: false
  end

  # Pas de « uninstall launchctl » : il couperait le hub à chaque brew upgrade. Le hub suit son app
  # lui-même : il redémarre sur une nouvelle version, et retire son service quand l'app disparaît.
  zap launchctl: "app.hom.mac",
      trash:     [
        "~/Library/Application Support/hom",
        "~/Library/Logs/hom",
      ]

  caveats <<~EOS
    Ouvre hom une première fois depuis le dossier Applications (ou : open -a hom).
    hom s'installe alors en tâche de fond, démarre avec ta session et s'ouvre dans
    ton navigateur (http://localhost:8765) : crée ton foyer et relie tes écrans.
    Les mises à jour (brew upgrade) prennent effet toutes seules.
    Tes données restent dans ~/Library/Application Support/hom
    (brew uninstall --zap hom les efface).
  EOS
end
