package xtendfx.properties

import java.lang.reflect.Modifier
import javafx.beans.property.SimpleStringProperty
import org.eclipse.xtend.core.compiler.batch.XtendCompilerTester
import org.junit.Test

import static org.junit.Assert.*

class FxBeanTest {
	
	static extension XtendCompilerTester compiler = XtendCompilerTester::newXtendCompilerTester(typeof(FXBean), typeof(SimpleStringProperty))
	
	@Test def testAgainstCompiledClass() {
		'''
			import xtendfx.properties.FXBean
			import java.util.Currency
			
			@FXBean class MyBean {
				String stringTypeWithDefault = ""
				String StringType
				boolean booleanType
				Currency currency;
			}
		'''.compile [
			compiledClass.getDeclaredField("stringTypeWithDefaultProperty") => [
				assertEquals(typeof(SimpleStringProperty), type)
				assertTrue(Modifier::isPrivate(modifiers))
			]
		]
	}
	
	@Test def testAgainstJavaSource() {
		'''
			import xtendfx.properties.FXBean
			import java.util.Currency
			
			@FXBean class MyBean {
				String stringTypeWithDefault = ""
				String StringType
				boolean booleanType
				Currency currency
			}
		'''.assertCompilesTo('''
			import java.util.Currency;
			import javafx.beans.property.SimpleBooleanProperty;
			import javafx.beans.property.SimpleObjectProperty;
			import javafx.beans.property.SimpleStringProperty;
			import xtendfx.properties.FXBean;
			
			@FXBean
			@SuppressWarnings("all")
			public class MyBean {
			  private String stringTypeWithDefault = "";
			  
			  private String StringType;
			  
			  private boolean booleanType;
			  
			  private Currency currency;
			  
			  private SimpleStringProperty stringTypeWithDefaultProperty;
			  
			  public String getStringTypeWithDefault() {
			    return (this.stringTypeWithDefaultProperty != null)? this.stringTypeWithDefaultProperty.get() : this.stringTypeWithDefault;
			    
			  }
			  
			  public void setStringTypeWithDefault(final String stringTypeWithDefault) {
			    if (stringTypeWithDefaultProperty != null) {
			    	this.stringTypeWithDefaultProperty.set(stringTypeWithDefault);
			    } else {
			    	this.stringTypeWithDefault = stringTypeWithDefault;
			    }
			    
			  }
			  
			  public SimpleStringProperty stringTypeWithDefaultProperty() {
			    if (this.stringTypeWithDefaultProperty == null) { 
			    	this.stringTypeWithDefaultProperty = new SimpleStringProperty(this, "stringTypeWithDefault", this.stringTypeWithDefault);
			    }
			    return this.stringTypeWithDefaultProperty;
			    
			  }
			  
			  private SimpleStringProperty StringTypeProperty;
			  
			  public String getStringType() {
			    return (this.StringTypeProperty != null)? this.StringTypeProperty.get() : this.StringType;
			    
			  }
			  
			  public void setStringType(final String StringType) {
			    if (StringTypeProperty != null) {
			    	this.StringTypeProperty.set(StringType);
			    } else {
			    	this.StringType = StringType;
			    }
			    
			  }
			  
			  public SimpleStringProperty StringTypeProperty() {
			    if (this.StringTypeProperty == null) { 
			    	this.StringTypeProperty = new SimpleStringProperty(this, "StringType", this.StringType);
			    }
			    return this.StringTypeProperty;
			    
			  }
			  
			  private SimpleBooleanProperty booleanTypeProperty;
			  
			  public boolean getBooleanType() {
			    return (this.booleanTypeProperty != null)? this.booleanTypeProperty.get() : this.booleanType;
			    
			  }
			  
			  public void setBooleanType(final boolean booleanType) {
			    if (booleanTypeProperty != null) {
			    	this.booleanTypeProperty.set(booleanType);
			    } else {
			    	this.booleanType = booleanType;
			    }
			    
			  }
			  
			  public SimpleBooleanProperty booleanTypeProperty() {
			    if (this.booleanTypeProperty == null) { 
			    	this.booleanTypeProperty = new SimpleBooleanProperty(this, "booleanType", this.booleanType);
			    }
			    return this.booleanTypeProperty;
			    
			  }
			  
			  private SimpleObjectProperty<Currency> currencyProperty;
			  
			  public Currency getCurrency() {
			    return (this.currencyProperty != null)? this.currencyProperty.get() : this.currency;
			    
			  }
			  
			  public void setCurrency(final Currency currency) {
			    if (currencyProperty != null) {
			    	this.currencyProperty.set(currency);
			    } else {
			    	this.currency = currency;
			    }
			    
			  }
			  
			  public SimpleObjectProperty<Currency> currencyProperty() {
			    if (this.currencyProperty == null) { 
			    	this.currencyProperty = new SimpleObjectProperty<Currency>(this, "currency", this.currency);
			    }
			    return this.currencyProperty;
			    
			  }
			}
		''')
	}
}