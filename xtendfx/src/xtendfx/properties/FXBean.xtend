package xtendfx.properties

import java.util.List
import javafx.beans.property.SimpleObjectProperty
import javafx.beans.property.SimpleBooleanProperty
import javafx.beans.property.SimpleDoubleProperty
import javafx.beans.property.SimpleFloatProperty
import javafx.beans.property.SimpleIntegerProperty
import javafx.beans.property.SimpleListProperty
import javafx.beans.property.SimpleLongProperty
import javafx.beans.property.SimpleStringProperty
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.TransformationParticipant
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.TypeReference

/**
 * An active annotation which turns simple fields into
 * lazy JavaFX properties as described  
 * <a href="http://blog.netopyr.com/2011/05/19/creating-javafx-properties/">here</a>.
 * 
 * That is it 
 * <ul>
 *  <li> adds a field with the corresponding JavaFX property type,
 *  <li> a getter method
 *  <li> a setter method
 *  <li> and an accessor to the JavaFX property.
 * </ul>
 */
@Active(typeof(FxBeanCompilationParticipant))
annotation FXBean {
}

class FxBeanCompilationParticipant implements TransformationParticipant<MutableClassDeclaration> {
	
	override doTransform(List<? extends MutableClassDeclaration> classes, extension TransformationContext context) {
		for (clazz : classes) {
			for (f : clazz.declaredFields) {
				val fieldName = f.simpleName
				val fieldType = f.type
				val propName = f.simpleName+'Property'
				val propType = f.type.toPropertyType(context)
				
				// add the property field
				clazz.addField(propName) [
					type = propType	
				]
				
				// add the getter
				clazz.addMethod('get'+fieldName.toFirstUpper) [
					returnType = fieldType
					body = ['''
						return (this.«propName» != null)? this.«propName».get() : this.«fieldName»;
					''']
				]
				
				// add the setter
				clazz.addMethod('set'+fieldName.toFirstUpper) [
					addParameter(fieldName, fieldType)
					body = ['''
						if («propName» != null) {
							this.«propName».set(«fieldName»);
						} else {
							this.«fieldName» = «fieldName»;
						}
					''']
				]
				
				// add the property accessor
				clazz.addMethod(fieldName+'Property') [
					returnType = propType
					body = ['''
						if (this.«propName» == null) { 
							this.«propName» = new «toJavaCode(propType)»(this, "«fieldName»", this.«fieldName»);
						}
						return this.«propName»;
					''']
				]
			}
		}
	}
	
	def boolean isImmutatableType (TypeReference ref) {
		return true;
	}
	
	def TypeReference toPropertyType(TypeReference ref, extension TransformationContext context) {
		switch ref.toString {
			case 'boolean' : typeof(SimpleBooleanProperty).newTypeReference
			case 'double' : typeof(SimpleDoubleProperty).newTypeReference
			case 'float' : typeof(SimpleFloatProperty).newTypeReference
			case 'long' : typeof(SimpleLongProperty).newTypeReference
			case 'String' : typeof(SimpleStringProperty).newTypeReference  
			case 'int' : typeof(SimpleIntegerProperty).newTypeReference
			case 'javafx.collections.ObservableList' :  typeof(SimpleListProperty).newTypeReference(ref.actualTypeArguments.head)
			default : typeof(SimpleObjectProperty).newTypeReference(ref)
		}
	}
	
}