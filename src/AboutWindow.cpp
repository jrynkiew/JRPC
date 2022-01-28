#include "hello_imgui/hello_imgui.h"
#include "imgui_utilities/MarkdownHelper.h"
#include "source_parse/Sources.h"
#include "AboutWindow.h"

#include <fplus/fplus.hpp>

AboutWindow::AboutWindow()
    : mLibrariesCodeBrowser("AboutWindow", SourceParse::jrpcWebOS(), "Solidity/JRPC.sol")
{
}

void AboutWindow::gui()
{
    guiHelp();
    mLibrariesCodeBrowser.gui();
}

void AboutWindow::guiHelp()
{
    static bool showHelp = true;
    if (showHelp)
    {
        std::string help = R"(
JRPC is a blockchain app which allows for detailed analysis and interaction of the blockchain! It currently allows you to preview Solidity contracts under construction for the IoTeX blockchain.

* [IoTeX](https://iotex.io/)
* JRPC Static webpage (To Do)
* [JRPC GitHub](https://github.com/jrynkiew/imgui_manual)

Please join us on social media:

* [Telegram](https://t.me/JRPC_Official)
* [Twitter](https://twitter.com/Jeremi_JRPC)

)";

        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.4f, 0.4f, 1.0f)); ImGui::TextWrapped("This website is meant for developers only!"); ImGui::PopStyleColor();
        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.4f, 0.4f, 1.0f)); ImGui::TextWrapped("It is still under construction and all contracts listed below are only tests!"); ImGui::PopStyleColor();
        MarkdownHelper::Markdown(help.c_str());
        if (ImGui::Button(ICON_FA_THUMBS_UP " Got it"))
            showHelp = false;
        MarkdownHelper::Markdown("\n");
    }
}