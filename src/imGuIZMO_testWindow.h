#pragma once
#include "../external/imGuIZMO.quat/imGuIZMO.quat/imGuIZMOquat.h"
#include "hello_imgui/hello_imgui.h"
#include "hello_imgui/widgets/logger.h"

//#ifdef HELLOIMGUI_USE_SDL_OPENGL3
#include <SDL2/SDL.h>
#include <SDL2/SDL_opengl.h>
//#endif

class imGuIZMO_testWindow
{
public:
    imGuIZMO_testWindow(HelloImGui::RunnerParams *runnerParams);
    void gui();
    bool visible;
    //void setRotation(const quat &q) { qRot = q; }
    //quat& getRotation() { return qRot; }

    vg::vGizmo3D gizmo; 
    vg::vGizmo3D &getGizmo() { return gizmo; }

    void setRotation(const quat &q) { getGizmo().setRotation(q); }
    quat getRotation() { return getGizmo().getRotation(); }

    void setPosition(const vec3 &p) { getGizmo().setPosition(p); }
    vec3 getPosition() { return getGizmo().getPosition(); }

    virtual void onIdle();
    virtual void onReshape(GLint w, GLint h);

    virtual void onMouseButton(int button, int upOrDown, int x, int y);
    virtual void onMouseWheel(int wheel, int direction, int x, int y);
    virtual void onMotion(int x, int y);

    virtual void onKeyDown(unsigned char key, int x, int y);
    virtual void onKeyUp(unsigned char key, int x, int y);
    virtual void onSpecialKeyUp(int key, int x, int y);
    virtual void onSpecialKeyDown(int key, int x, int y);

private:
    void display3Dwidget();
    HelloImGui::RunnerParams *params;
    
    vec3 PanDolly = vec3(0.f);
    quat qRot = quat(1.f, 0.f, 0.f, 0.f);
    vec3 tLight;
};

