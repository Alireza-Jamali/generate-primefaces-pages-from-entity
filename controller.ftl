<#if comment>

  TEMPLATE DESCRIPTION:

  This is Java template for 'JSF Pages From Entity Beans' controller class. Templating
  is performed using FreeMaker (http://freemarker.org/) - see its documentation
  for full syntax. Variables available for templating are:

    controllerClassName - controller class name (type: String)
    controllerPackageName - controller package name (type: String)
    entityClassName - entity class name without package (type: String)
    importEntityFullClassName - whether to import entityFullClassName or not
    entityFullClassName - fully qualified entity class name (type: String)
    ejbClassName - EJB class name (type: String)
    importEjbFullClassName - whether to import ejbFullClassName or not
    ejbFullClassName - fully qualified EJB class name (type: String)
    managedBeanName - name of managed bean (type: String)
    keyEmbedded - is entity primary key is an embeddable class (type: Boolean)
    keyType - fully qualified class name of entity primary key
    keyBody - body of Controller.Converter.getKey() method
    keyStringBody - body of Controller.Converter.getStringKey() method
    keyGetter - entity getter method returning primaty key instance
    keySetter - entity setter method to set primary key instance
    embeddedIdFields - contains information about embedded primary IDs
    cdiEnabled - project contains beans.xml, so Named beans can be used
    bundle - name of the variable defined in the JSF config file for the resource bundle (type: String)

  This template is accessible via top level menu Tools->Templates and can
  be found in category JavaServer Faces->JSF from Entity.

</#if>
package ${controllerPackageName};

<#if importEntityFullClassName?? && importEntityFullClassName == true>
import ${entityFullClassName};
</#if>
import ${controllerPackageName?replace(".mbean","")}.util.JsfUtil;
import ${controllerPackageName?replace(".mbean","")}.util.JsfUtil.PersistAction;
<#if importEjbFullClassName?? && importEjbFullClassName == true>
    <#if ejbClassName??>
import ${ejbFullClassName};
    <#elseif jpaControllerClassName??>
import ${jpaControllerFullClassName};
    </#if>
</#if>

import java.io.Serializable;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
<#if isInjected?? && isInjected==true>
import javax.annotation.Resource;
</#if>
<#if ejbClassName??>
import javax.ejb.EJB;
</#if>
<#if managedBeanName??>
<#if cdiEnabled?? && cdiEnabled>
import javax.inject.Named;
import javax.faces.view.ViewScoped;
<#else>
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
</#if>
</#if>
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.convert.Converter;
import javax.faces.convert.FacesConverter;
<#if jpaControllerClassName??>
  <#if isInjected?? && isInjected==true>
import javax.persistence.EntityManagerFactory;
import javax.persistence.PersistenceUnit;
import javax.transaction.UserTransaction;
  <#else>
import javax.persistence.Persistence;
  </#if>
</#if>


<#if managedBeanName??>
<#if cdiEnabled?? && cdiEnabled>
@Named
<#else>
@ManagedBean(name="${managedBeanName}")
</#if>
@ViewScoped
</#if>
public class ${controllerClassName} implements Serializable {

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

    public void prepareCreate() {
		set${entityClassName}Editable(true);
        selected${entityClassName} = new ${entityClassName}();
    }    
	
    public void edit() {
        set${entityClassName}Editable(true);
    }
	
	public void reset() {
		${entityClassName?uncap_first}List = null;
		findFetchSelected${entityClassName}();
	}
	
	private void findFetchSelected${entityClassName}() {
//		if(selected${entityClassName} == null || selected${entityClassName}.getId() == null) {
//            return;
//        }
//        selected${entityClassName} = ${ejbClassName?uncap_first}.findFetch(selected${entityClassName}.getId(), fetch -> {
//            if(fetch.getTODO() != null) {
//                fetch.getTODO().size();
//            }
//        });
	}
	
	public void prepareSimilarCreate() {
	    set${entityClassName}Editable(true);
		selected${entityClassName} = ${ejbClassName?uncap_first}.clone(selected${entityClassName});
    }    
	
	public void refresh() {
        ${entityClassName?uncap_first}List = null;
    }

    public void save(boolean andCreate) {
		${entityClassName} merged${entityClassName} = ${ejbClassName?uncap_first}.persist(selected${entityClassName},selected${entityClassName}.getId() != null ? PersistAction.UPDATE : PersistAction.CREATE);
		if(merged${entityClassName} != null) {
			if(andCreate) {
				prepareCreate();
				${entityClassName?uncap_first}List = null;
			} else  {
				selected${entityClassName} = merged${entityClassName};
				set${entityClassName}Editable(false);
				reset();
			}
		}
    }
	
	public void cancel() {
	    set${entityClassName}Editable(false);
        reset();
    }

    public void destroy() {
        ${entityClassName} merged${entityClassName} = ${ejbClassName?uncap_first}.persist(selected${entityClassName},  PersistAction.DELETE);
		if(merged${entityClassName} != null) {
			selected${entityClassName} = null; // Remove selection
			${entityClassName?uncap_first}List = null;    // Invalidate list of items to trigger re-query.
        }
    }

    public List<${entityClassName}> get${entityClassName}List() {
        if (${entityClassName?uncap_first}List == null) {
<#if ejbClassName??>
            ${entityClassName?uncap_first}List = ${ejbClassName?uncap_first}.findAll();
<#elseif jpaControllerClassName??>
            ${entityClassName?uncap_first}List = getJpaController().find${entityClassName}Entities();
</#if>
        }
        return ${entityClassName?uncap_first}List;
    }

    public List<${entityClassName}> getItemsAvailableSelectOne() {
<#if ejbClassName??>
        return ${ejbClassName?uncap_first}.findAll();
<#elseif jpaControllerClassName??>
        return getJpaController().find${entityClassName}Entities();
</#if>
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
		findFetchSelected${entityClassName}();
    }
}



//---


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
        if (value == null || value.trim().length() == 0) {
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