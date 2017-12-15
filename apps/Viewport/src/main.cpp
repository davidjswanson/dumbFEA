#include <iostream>

#include <nanogui/nanogui.h>
#include <nanogui/opengl.h>
#include <nanogui/window.h>
#include <nanogui/layout.h>
#include <nanogui/slider.h>
#include <nanogui/textbox.h>
#include <nanogui/glcanvas.h>
#include <nanogui/opengl.h>
#include <nanogui/glutil.h>

class TestApp : public nanogui::Screen {
public:
	TestApp() : nanogui::Screen(Eigen::Vector2i(1024, 768), "Test App"), r(0), g(0), b(0), a(1), angle(0) {
		using namespace nanogui;
		Window* window = new Window(this);
		window->setTitle("Window");
		window->setLayout(new GroupLayout());
		window->setPosition(Vector2i(15, 15));

		Widget* panel = new Widget(window);
		panel->setLayout(new BoxLayout(Orientation::Horizontal, Alignment::Middle, 0, 0));

		addVariableSlider(panel, r, "Red");
		addVariableSlider(panel, g, "Green");
		addVariableSlider(panel, b, "Blue");

		addVariableSlider(window, angle, "Angle");

		performLayout();

		shader.init(
			/* An identifying name */
			"a_simple_shader",

			/* Vertex shader */
			"#version 330\n"
			"uniform mat4 modelViewProj;\n"
			"in vec3 position;\n"
			"out vec3 pos;\n"
			"void main() {\n"
			"    pos = position;\n"
			"    gl_Position = modelViewProj * vec4(position, 1.0);\n"
			"}",

			/* Fragment shader */
			"#version 330\n"
			"in vec3 pos;\n"
			"out vec4 color;\n"
			"uniform float intensity;\n"
			"void main() {\n"
			//"    color = vec4(vec3(intensity), 1.0);\n"
			"    color = vec4((pos/2.0 + vec3(1.0))*intensity, 1.0);\n"
			"}"
		);


		MatrixXu indices(3, 2); /* Draw 2 triangles */
		indices.col(0) << 0, 1, 2;
		indices.col(1) << 2, 3, 0;

		MatrixXf positions(3, 4);
		positions.col(0) << -1, -1, 0;
		positions.col(1) << 1, -1, 0;
		positions.col(2) << 1, 1, 0;
		positions.col(3) << -1, 1, 0;

		shader.bind();
		shader.uploadIndices(indices);
		shader.uploadAttrib("position", positions);
		shader.setUniform("intensity", 0.5f);
	}

	void drawContents() {
		glClearColor(r,g,b,1);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

		using namespace nanogui;

		/* Draw the window contents using OpenGL */
		shader.bind();

		Matrix4f mvp;
		mvp.setIdentity();
		mvp.topLeftCorner<3, 3>() = Matrix3f(Eigen::AngleAxisf((float)angle*2.0*3.14159, Vector3f::UnitZ())) * 0.25f;
		mvp.row(0) *= (float)mSize.y() / (float)mSize.x();
		shader.setUniform("modelViewProj", mvp);

		/* Draw 2 triangles starting at index 0 */
		shader.drawIndexed(GL_TRIANGLES, 0, 2);
	}

private:
	void addVariableSlider(Widget* parent, float& var, const std::string& fieldName, const std::function<void(float)>& lambda = [](float value) {}) {
		using namespace nanogui;
		Label* label = new Label(parent, fieldName);
		Slider* slider = new Slider(parent);
		slider->setFixedWidth(80);
		slider->setValue(var);
		slider->setCallback([&var, lambda](float value) {
			var = value;
			lambda(value);
		});
	}

	float r, g, b, a;
	float angle;
	nanogui::GLShader shader;
};

int main(int argc, char**argv) {
	nanogui::init();

	nanogui::Screen* screen = new TestApp();

	screen->performLayout();
	screen->drawAll();
	screen->setVisible(true);

	nanogui::mainloop();
	nanogui::shutdown();

	return 0;
}


