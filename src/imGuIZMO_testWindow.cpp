
#include "imgui_utilities/MarkdownHelper.h"
#include "source_parse/Sources.h"
#include "imGuIZMO_testWindow.h"


//
/////////////////////////////////////////////////
void imGuIZMO_testWindow::onIdle()
{
#ifdef GLAPP_USE_VIRTUALGIZMO 
    getGizmo().idle();
#endif
}


//
/////////////////////////////////////////////////
void imGuIZMO_testWindow::onReshape(GLint w, GLint h)
{
    glViewport(0,0,w,h);
    //theApp->SetWidth(w); theApp->SetHeight(h);

#ifdef GLAPP_USE_VIRTUALGIZMO 
    getGizmo().viewportSize(w, h);
#endif
}

//
/////////////////////////////////////////////////
void imGuIZMO_testWindow::onKeyUp(unsigned char key, int x, int y)
{

}


//
/////////////////////////////////////////////////
void imGuIZMO_testWindow::onSpecialKeyDown(int key, int x, int y)
{


}


//
/////////////////////////////////////////////////
void imGuIZMO_testWindow::onKeyDown(unsigned char key, int x, int y)
{



}



//
/////////////////////////////////////////////////
void imGuIZMO_testWindow::onSpecialKeyUp(int key, int x, int y)
{



}


//
/////////////////////////////////////////////////
void imGuIZMO_testWindow::onMouseButton(int button, int upOrDown, int x, int y)
{

#ifdef GLAPP_USE_VIRTUALGIZMO 
    getGizmo().mouse((vgButtons) (button),
                    (vgModifiers) theApp->getModifier(),
#ifdef GLAPP_USE_SDL
                    upOrDown==SDL_MOUSEBUTTONDOWN, x, y);
#else
                    upOrDown==GLFW_PRESS, x, y);
#endif
#endif

}

//
/////////////////////////////////////////////////
void imGuIZMO_testWindow::onMouseWheel(int wheel, int direction, int x, int y)
{

}

//
/////////////////////////////////////////////////
void imGuIZMO_testWindow::onMotion(int x, int y)
{
#ifdef GLAPP_USE_VIRTUALGIZMO 
    getGizmo().motion(x, y);
#endif

    //qjSet->matOrientation *= trackball.getDollyPosition();
    
}

imGuIZMO_testWindow::imGuIZMO_testWindow(HelloImGui::RunnerParams *runnerParams)
{
    params = runnerParams;
    visible = true;

    HelloImGui::Widgets::Logger logger("Logs", "BottomSpace");

    /*params->callbacks.AnyBackendEventCallback = [&logger](void * event) {  
#ifdef HELLOIMGUI_USE_SDL_OPENGL3
        SDL_Event*  sdlEvent = (SDL_Event *)event;
        switch( sdlEvent->type)
        {
            case SDL_KEYDOWN:
                logger.warning( "SDL_KEYDOWN detected\n" );
                return false; // if you return true, the event is not processd further
            case SDL_MOUSEBUTTONDOWN:
                theWnd->onMouseButton(event.button.button, SDL_MOUSEBUTTONDOWN, event.button.x, event.button.y); 
                return true;
            case SDL_MOUSEBUTTONUP:
                theWnd->onMouseButton(event.button.button, SDL_MOUSEBUTTONUP, event.button.x, event.button.y);
                return true;
        }
        return false;
#else
        return false;
#endif
    };*/

    SDL_Event event;
        while (SDL_PollEvent(&event))
        {
            /*ImGui_ImplSDL2_ProcessEvent(&event);
            if (event.type == SDL_QUIT)
                done = true;
            if (event.type == SDL_WINDOWEVENT && event.window.event == SDL_WINDOWEVENT_CLOSE && event.window.windowID == SDL_GetWindowID(mainSDLWwnd))
                done = true;
            if (event.type == SDL_MOUSEBUTTONDOWN) {
                theWnd->onMouseButton(event.button.button, SDL_MOUSEBUTTONDOWN, event.button.x, event.button.y); 
            }
            if (event.type == SDL_MOUSEBUTTONUP) {
                theWnd->onMouseButton(event.button.button, SDL_MOUSEBUTTONUP, event.button.x, event.button.y);
            }
            if (event.type == SDL_MOUSEMOTION) {
                theWnd->onMotion(event.motion.x, event.motion.y);
            }
    */

        }
}

void imGuIZMO_testWindow::gui()
{
    display3Dwidget();
}

tVec2 getMousePosition() //helper
{
    int maxPosX;
    int minPosX;

    int maxPosY;
    int minPosY;

    //ImGuiID mainDockspaceId = ImGui::GetID("MainDockSpace");
    //auto centeralNode = ImGui::DockBuilderGetCentralNode(mainDockspaceId);

    ImGuiIO& io = ImGui::GetIO();
    ImGuiContext& g = *GImGui;

    //maxPosX = centeralNode->Size.x + centeralNode->Pos.x;
    maxPosX = io.DisplaySize.x;

    minPosX = 0;

    printf("%d\n", maxPosX);
    
    minPosY = io.DisplaySize.y;
    maxPosY = 0;

    //normalize data

    float normalizedX = (io.MousePos.x - minPosX) / (maxPosX - minPosX);
    float normalizedY = (io.MousePos.y - minPosY) / (maxPosY - minPosY);

    return tVec2(normalizedX, normalizedY);
}

void imGuIZMO_testWindow::display3Dwidget()
{
    /*if(ImGui::IsMouseDown(0))
    {
        if(io.MousePos.x > centeralNode->Pos.x && io.MousePos.x < centeralNode->Size.x + centeralNode->Pos.x)
        {
            params->qjSet->position.x = getMousePosition().x + (io.MousePos.x - centeralNode->Pos.x) / (centeralNode->Size.x + centeralNode->Pos.x - centeralNode->Pos.x); 
            params->qjSet->position.y = getMousePosition().y - (((params->qjSet->sizeY*1.5) - centeralNode->Size.y) / (params->qjSet->sizeY));
        }
    }*/

    quat qt = getRotation();
    vec3 pos = getPosition();

    mat4 modelMatrix = mat4_cast(quat(1.f, 0.2f, 0.f, 1.f));
    if(visible)
    {
        ImGui::PushStyleColor(ImGuiCol_WindowBg, ImVec4(0.f,0.f,0.f,0.f));
        ImGui::PushStyleColor(ImGuiCol_FrameBg, ImVec4(0.f,0.f,0.f,0.f));
        //ImGui::SetNextWindowPos(ImGui::DockBuilderGetNode(ImGui::FindWindowByName("About JRPC")->DockNode->ID)->Pos,ImGuiCond_FirstUseEver);
        ImGui::Begin("3D Widget", &visible, ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoBackground | ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize);
        if(ImGui::gizmo3D("##gizmo1", pos, qt, 200, 1)) 
        {  
            //Set gizmo rotation (not model)
            setRotation(qt); 
            setPosition(pos);
            //Transform
            //params->qjSet->quatPt.x = qt.x;
            //params->qjSet->quatPt.y = qt.y;
            //params->qjSet->quatPt.z = qt.z;
            //params->qjSet->quatPt.w = qt.w;

            //This whole rotation mechanism needs to be done on mouse event in SDL_Event or glfw event
            //Code available in external libraries

            //Rotate
            params->qjSet->matOrientation = getGizmo().getTransform();
            params->qjSet->position = getGizmo().getPosition();
            //params->qjSet->Light = 
        }
        ImGui::End();
        ImGui::PopStyleColor();
        ImGui::PopStyleColor();
    }
}
