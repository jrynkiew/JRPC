#pragma once

// ImGui headers
#include <imgui.h>

namespace ImGui
{
	// WebOS Set Styles
	IMGUI_API void          StyleColorsJRPC();
}

class WebOS {
private:
	ImGuiStyle* imGuiStylePtr; 


public:
 	void setStyle();
	
	WebOS();
	~WebOS();
};