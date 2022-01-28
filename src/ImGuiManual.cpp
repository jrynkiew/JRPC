#include "AboutWindow.h"
#include "Acknowledgments.h"
#include "MenuTheme.h"
#include "imGuIZMO_testWindow.h"

#include "imgui_utilities/MarkdownHelper.h"

#include "hello_imgui/hello_imgui.h"
#include "hello_imgui/widgets/logger.h"

#include "JsClipboardTricks.h"

#include "../external/hello_imgui/src/hello_imgui/internal/backend_impls/qJulia.h"

HelloImGui::RunnerParams runnerParams;

int main(int, char **)
{
    Acknowledgments acknowledgments;
    AboutWindow aboutWindow;
    imGuIZMO_testWindow ImGuIZMO_testWindow(&runnerParams);
    //
    // Below, we will define all our application parameters and callbacks
    // before starting it.
    //

    // App window params
    runnerParams.appWindowParams.windowTitle = "IoTeX JRPC Console";
    runnerParams.appWindowParams.windowSize = { 1200, 800 };

    // ImGui window params
    runnerParams.imGuiWindowParams.defaultImGuiWindowType =
            HelloImGui::DefaultImGuiWindowType::ProvideFullScreenDockSpace;
    runnerParams.imGuiWindowParams.showMenuBar = true;
    runnerParams.imGuiWindowParams.showStatusBar = true;
    runnerParams.imGuiWindowParams.backgroundColor = ImVec4(0.20f, 0.20f, 0.20f, 1.00f);
    // Split the screen in two parts (two "DockSpaces")
    // This will split the preexisting default dockspace "MainDockSpace"
    // in two parts:
    // "MainDockSpace" will be on the left, "CodeSpace" will be on the right
    // and occupy 65% of the app width.
    runnerParams.dockingParams.dockingSplits = {
        { "MainDockSpace", "CodeSpace", ImGuiDir_Right, 0.45f },
        { "MainDockSpace", "LeftMenuSpace", ImGuiDir_Left, 0.2f },
        { "LeftMenuSpace", "Test", ImGuiDir_Down, 0.25f },
    };

    //
    // Dockable windows definitions
    //
    {
        HelloImGui::DockableWindow dock_imguiDemoWindow;
        {
            dock_imguiDemoWindow.label = "Dear ImGui Demo";
            dock_imguiDemoWindow.dockSpaceName = "LeftMenuSpace";// This window goes into "MainDockSpace"
            dock_imguiDemoWindow.GuiFonction = [&dock_imguiDemoWindow] {
                if (dock_imguiDemoWindow.isVisible)
                    ImGui::ShowDemoWindow(nullptr);
            };
            dock_imguiDemoWindow.callBeginEnd = false;
        };

        HelloImGui::DockableWindow dock_acknowledgments;
        {
            dock_acknowledgments.label = "Acknowledgments";
            dock_acknowledgments.dockSpaceName = "CodeSpace";
            dock_acknowledgments.isVisible = false;
            dock_acknowledgments.includeInViewMenu = false;
            dock_acknowledgments.GuiFonction = [&acknowledgments] { acknowledgments.gui(); };
        };

        HelloImGui::DockableWindow dock_about;
        {
            dock_about.label = "About JRPC";
            dock_about.dockSpaceName = "CodeSpace";
            dock_about.isVisible = true;
            dock_about.includeInViewMenu = false;
            dock_about.GuiFonction = [&aboutWindow] { aboutWindow.gui(); };
        };

        HelloImGui::DockableWindow dock_imGuIZMOquat;
        {
            dock_imGuIZMOquat.label = "3D Widget";
            dock_imGuIZMOquat.dockSpaceName = "Test";
            dock_imGuIZMOquat.isVisible = true;
            dock_imGuIZMOquat.imGuiWindowFlags =  ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoBackground;
            dock_imGuIZMOquat.windowSize = ImVec2(490, 450);
            dock_imGuIZMOquat.includeInViewMenu = true;
            dock_imGuIZMOquat.GuiFonction = [&ImGuIZMO_testWindow] { ImGuIZMO_testWindow.gui(); };
            dock_imGuIZMOquat.callBeginEnd = false;
        };

        //
        // Set our app dockable windows list
        //
        runnerParams.dockingParams.dockableWindows = {
            dock_imguiDemoWindow,
            dock_imGuIZMOquat,
            dock_acknowledgments,
            dock_about
        };
    }

    // Set the app menu
    runnerParams.callbacks.ShowMenus = []{
        menuTheme();

        HelloImGui::DockableWindow *aboutWindow =
            runnerParams.dockingParams.dockableWindowOfName("About JRPC");
          HelloImGui::DockableWindow *acknowledgmentWindow =
              runnerParams.dockingParams.dockableWindowOfName("Acknowledgments");
        if (aboutWindow && ImGui::BeginMenu("About"))
        {
            if (ImGui::MenuItem("About IoTeX & JRPC"))
                aboutWindow->isVisible = true;
            if (ImGui::MenuItem("Acknowledgments"))
                acknowledgmentWindow->isVisible = true;
            ImGui::EndMenu();
        }
    };

    // Add some widgets in the status bar
    runnerParams.callbacks.ShowStatus = [] {
        MarkdownHelper::Markdown("IoTeX Project Grants - [Halogrants](https://github.com/iotexproject/halogrants)");
    };

    // Set the custom fonts
    runnerParams.callbacks.LoadAdditionalFonts = []() {
      HelloImGui::ImGuiDefaultSettings::LoadDefaultFont_WithFontAwesomeIcons();
      LoadMonospaceFont();
      MarkdownHelper::LoadFonts();
    };

    // Ready, set, go!
#ifdef IMGUIMANUAL_CLIPBOARD_IMPORT_FROM_BROWSER
    JsClipboard_AddJsHook();
#endif
    HelloImGui::Widgets::Logger logger("Logs", "BottomSpace");

    runnerParams.callbacks.AnyBackendEventCallback = [&logger](void * event) {  
                logger.warning( "SDL_KEYDOWN detected\n" );
                return false; // if you return true, the event is not processd further
    };

    HelloImGui::Run(runnerParams);
    return 0;
}