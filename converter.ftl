package serp3.converter;

import serp3.dbservice.GenericDatabaseService;
import ${entityFullClassName};
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.convert.Converter;
import javax.faces.convert.FacesConverter;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import java.util.logging.Level;
import java.util.logging.Logger;

@FacesConverter(forClass = ${entityClassName}.class)
public  class ${entityClassName}Converter implements Converter {

    @Override
    public Object getAsObject(FacesContext facesContext, UIComponent component, String value) {
        if (value == null || value.length() == 0) {
            return null;
        }
        try {
        return ((GenericDatabaseService) InitialContext.doLookup("java:module/GenericDatabaseService")).find(${entityClassName}.class, Long.valueOf(value));
        } catch (NamingException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public String getAsString(FacesContext facesContext, UIComponent component, Object object) {
        if (object == null || object.equals("")) {
            return "";
        }
        if (object instanceof ${entityClassName}) {
        ${entityClassName} o = (${entityClassName}) object;
            return o.getId().toString();
        } else {
        Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, "object {0} is of type {1}; expected type: {2}", new Object[]{object, object.getClass().getName(), ${entityClassName}.class.getName()});
            return null;
        }
    }
}










<#if isInjected?? && isInjected==true>
@Resource
private UserTransaction utx = null;
@PersistenceUnit<#if persistenceUnitName??>(unitName = "${persistenceUnitName}")</#if>
private EntityManagerFactory emf = null;
</#if>

<#if ejbClassName??>
@EJB private ${ejbClassName} ${ejbClassName?uncap_first};
<#elseif jpaControllerClassName??>
private ${jpaControllerClassName} ${jpaControllerClassName?uncap_first}Controller;
</#if>
private List<${entityClassName}> ${entityClassName?uncap_first}List;
private ${entityClassName} selected${entityClassName};
private boolean ${entityClassName?uncap_first}Editable;

public ${controllerClassName}() {
}

<#if ejbClassName??>
private ${ejbClassName} getFacade() {
return ${ejbClassName?uncap_first};
}
<#elseif jpaControllerClassName??>
private ${jpaControllerClassName} getJpaController() {
if (jpaController == null) {
<#if isInjected?? && isInjected==true>
jpaController = new ${jpaControllerClassName}(utx, emf);
<#else>
jpaController = new ${jpaControllerClassName}(Persistence.createEntityManagerFactory(<#if persistenceUnitName??>"${persistenceUnitName}"</#if>));
</#if>
}
return jpaController;
}
</#if>

public void prepareCreate() {
set${entityClassName}Editable(true);
selected${entityClassName} = new ${entityClassName}();
}    

public void edit() {
set${entityClassName}Editable(true);
}

public void prepareSimilarCreate() {
set${entityClassName}Editable(true);

}    

public void refresh() {
        ${entityClassName?uncap_first}List = null;
selected${entityClassName} = getFacade().clone(selected${entityClassName});
}


public void save() {
set${entityClassName}Editable(false);
getFacade().persist(selected${entityClassName},  PersistAction.UPDATE);
selected${entityClassName} = null;
		${entityClassName?uncap_first}List = null;
}

public void cancel() {
set${entityClassName}Editable(false);
selected${entityClassName} = null;
}

public void destroy() {
set${entityClassName}Editable(false);
getFacade().persist(selected${entityClassName},  PersistAction.DELETE);
if (!JsfUtil.isValidationFailed()) {
selected${entityClassName} = null; // Remove selection
            ${entityClassName?uncap_first}List = null;    // Invalidate list of items to trigger re-query.
}
}

public List<${entityClassName}> get${entityClassName}List() {
if (${entityClassName?uncap_first}List == null) {
<#if ejbClassName??>
            ${entityClassName?uncap_first}List = getFacade().findAll();
<#elseif jpaControllerClassName??>
            ${entityClassName?uncap_first}List = getJpaController().find${entityClassName}Entities();
</#if>
}
return ${entityClassName?uncap_first}List;
}

<#if ejbClassName?? && cdiEnabled?? && cdiEnabled>
public ${entityClassName} get${entityClassName}(${keyType} id) {
return getFacade().find(id);
}
</#if>

public List<${entityClassName}> getItemsAvailableSelectOne() {
<#if ejbClassName??>
return getFacade().findAll();
<#elseif jpaControllerClassName??>
return getJpaController().find${entityClassName}Entities();
</#if>
}

@FacesConverter(forClass=${entityClassName}.class)
public static class ${controllerClassName}Converter implements Converter {

@Override
public Object getAsObject(FacesContext facesContext, UIComponent component, String value) {
if (value == null || value.length() == 0) {
return null;
}
            ${controllerClassName} controller = (${controllerClassName})facesContext.getApplication().getELResolver().
getValue(facesContext.getELContext(), null, "${managedBeanName}");
<#if ejbClassName??>
<#if cdiEnabled?? && cdiEnabled>
return controller.get${entityClassName}(Long.valueOf(value));
<#else>
return controller.getFacade().find(getKey(value));
</#if>
<#elseif jpaControllerClassName??>
return controller.getJpaController().find${entityClassName}(getKey(value));
</#if>
}

@Override
public String getAsString(FacesContext facesContext, UIComponent component, Object object) {
if (object == null || object.equals("")) {
return "";
}
if (object instanceof ${entityClassName}) {
                ${entityClassName} o = (${entityClassName}) object;
return o.${keyGetter}().toString();
} else {
Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, "object {0} is of type {1}; expected type: {2}", new Object[]{object, object.getClass().getName(), ${entityClassName}.class.getName()});
return null;
}
}

}
public void set${entityClassName}Editable(boolean editable) {
this.${entityClassName?uncap_first}Editable = editable;
}
public boolean is${entityClassName}Editable() {
return ${entityClassName?uncap_first}Editable;
}
public ${entityClassName} getSelected${entityClassName}() {
return selected${entityClassName};
}
public void setSelected${entityClassName}(${entityClassName} selected${entityClassName}) {
set${entityClassName}Editable(false);
this.selected${entityClassName} = selected${entityClassName};
}
}
