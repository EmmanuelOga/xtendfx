package xtendfx

import javafx.beans.property.SimpleStringProperty
import org.eclipse.xtend.core.compiler.batch.XtendCompilerTester
import org.junit.Test

import static org.junit.Assert.*

class FXAppTest {

	static extension XtendCompilerTester compiler = XtendCompilerTester::newXtendCompilerTester(typeof(FXApp), typeof(SimpleStringProperty))

	@Test def testAgainstJavaCode() {
		'''
			import xtendfx.FXApp
			import javafx.stage.Stage
			
			@FXApp class MyFxApp {
				override start(Stage it) {
					//TODO
				}
			}
		'''.assertCompilesTo('''
			import javafx.application.Application;
			import javafx.stage.Stage;
			import xtendfx.FXApp;
			
			@FXApp
			@SuppressWarnings("all")
			public class MyFxApp extends Application {
			  public void start(final Stage it) {
			  }
			  
			  public static void main(final String[] args) {
			    Application.launch(args);
			    
			  }
			}
		''')
	}
	
	@Test def testAgainstAST() {
		'''
			import xtendfx.FXApp
			import javafx.stage.Stage
			
			@FXApp class MyFxApp {
				override start(Stage it) {
					//TODO
				}
			}
		'''.compile[
			extension val ctx = transformationContext
			val unit = compilationUnit
			val clazz = ctx.findClass('MyFxApp')
			assertEquals('Application', clazz.superclass.simpleName)
			val mainMethod = clazz.findMethod('main', ctx.newArrayTypeReference(ctx.string))
			assertNotNull(mainMethod)
		]
	}
}
