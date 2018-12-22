<ui:composition id="${entityName}" xmlns="http://www.w3.org/1999/xhtml"
                xmlns:f="http://xmlns.jcp.org/jsf/core"
                xmlns:h="http://xmlns.jcp.org/jsf/html"
                xmlns:ui="http://xmlns.jcp.org/jsf/facelets"
                xmlns:p="http://primefaces.org/ui"
                template="/WEB-INF/template.xhtml">
    <ui:define name="content">
	<#list entityDescriptors as entityDescriptor>
		<#if entityDescriptor.id != "id" && entityDescriptor.id != "version" && entityDescriptor?index < 3>
			<p:focus id="${entityName}_focusIn" for=":${entityName}_detailForm:${entityName}_editForm_${entityDescriptor.id?replace(".","_")}"/>
	    </#if>
    </#list>
        <h:form id="${entityName}_listForm">
            <p:panel header="${r"#{"}${bundle}.${entityName}${r"}"}">
                <p:dataTable id="${entityName}_listForm_dataTable" value="${r"#{"}${managedBean}.${entityName?uncap_first}List${r"}"}" var="${entityName?uncap_first}Item"
                             selectionMode="single" selection="${r"#{"}${managedBean}.selected${entityName}}" emptyMessage="#{bundle.Datatable_filterEmptyMessage}"
                             paginator="true" paginatorAlwaysVisible="false" paginatorPosition="bottom" rowKey="${r"#{"}${entityName?uncap_first}Item.${entityIdField}${r"}"}" rows="10" rowsPerPageTemplate="10,20,30,40,50">
							 
                    <p:ajax event="rowSelect"   update=":${entityName}_editForm ${entityName}_listForm_btnsPanel"/>
                    <p:ajax event="rowUnselect" update=":${entityName}_editForm ${entityName}_listForm_btnsPanel"/>

					<#list entityDescriptors as entityDescriptor>
						<#if entityDescriptor.id != "id" && entityDescriptor.id != "version">
					<p:column headerText="${r"#{"}${bundle}.${entityDescriptor.id?replace(".","_")}${r"}"}">
						<#if entityDescriptor.dateTimeFormat?? && entityDescriptor.dateTimeFormat != "">
                            <h:outputText converter="JalaliDateConverter" value="${r"#{"}${entityDescriptor.name?replace("item.","${entityName?uncap_first}Item.")}${r"}"}"/>
						<#elseif entityDescriptor.returnType?matches(".*[Bb]+oolean")>
							<p:selectBooleanCheckbox value="${r"#{"}${entityDescriptor.name?replace("item.","${entityName?uncap_first}Item.")}${r"}"}" disabled="true"/>
						<#elseif entityDescriptor.returnType?matches(".*BigDecimal")>
							<h:outputText value="${r"#{"}${entityDescriptor.name?replace("item.","${entityName?uncap_first}Item.")}${r"}"}">
								<f:convertNumber maxFractionDigits="10"/>
							</h:outputText>
						<#elseif entityDescriptor.returnType?matches(".*Integer") || entityDescriptor.returnType?matches(".*Long")>
							<h:outputText value="${r"#{"}${entityDescriptor.name?replace("item.","${entityName?uncap_first}Item.")}${r"}"}">
								<f:convertNumber maxFractionDigits="0"/>
							</h:outputText>
						<#else>
                        <h:outputText value="${r"#{"}${entityDescriptor.name?replace("item.","${entityName?uncap_first}Item.")}${r"}"}"/>
						</#if>
                    </p:column>
							</#if>
					</#list>
                    <f:facet name="footer">
                        <p:outputPanel id="${entityName}_listForm_btnsPanel">
                            <p:commandButton id="${entityName}_listForm_createBtn" icon="ui-icon-plus" title="${r"#{"}${bundle}.Create${r"}"}" actionListener="${r"#{"}${managedBean}.prepareCreate${r"}"}" 
                                             update="${entityName}_listForm_btnsPanel ${entityName}_listForm_dataTable :${entityName}_editForm ${entityName}_focusIn"
                                             disabled="${r"#{"}${managedBean}.${entityName?uncap_first}Editable${r"}"}"/>

                            <p:commandButton id="${entityName}_listForm_editBtn" icon="ui-icon-pencil" title="${r"#{"}${bundle}.Edit${r"}"}" actionListener="${r"#{"}${managedBean}.edit${r"}"}" 
                                             update="${entityName}_listForm_btnsPanel :${entityName}_editForm ${entityName}_focusIn" 
                                             disabled="${r"#{"}empty ${managedBean}.selected${entityName} or ${managedBean}.${entityName?uncap_first}Editable${r"}"}"/>

                            <p:commandButton id="${entityName}_listForm_deleteBtn" icon="ui-icon-trash" title="${r"#{"}${bundle}.Delete${r"}"}" actionListener="${r"#{"}${managedBean}.destroy${r"}"}" 
                                             update=":${entityName}_editForm ${entityName}_listForm_dataTable" 
                                             disabled="${r"#{"}empty ${managedBean}.selected${entityName} or ${managedBean}.${entityName?uncap_first}Editable${r"}"}">
                                <p:confirm header="${r"#{"}${bundle}.ConfirmDialog_title${r"}"}" message="${r"#{"}${bundle}.ConfirmDialog_message${r"}"}" icon="ui-icon-alert" />
                                </p:commandButton>

                            <p:commandButton id="${entityName}_listForm_similarBtn" icon="fa fa-copy" title="${r"#{"}${bundle}.SimilarCreate${r"}"}" actionListener="${r"#{"}${managedBean}.prepareSimilarCreate${r"}"}" 
                                             update="${entityName}_listForm_btnsPanel ${entityName}_listForm_dataTable :${entityName}_editForm ${entityName}_focusIn"  
                                             disabled="${r"#{"}empty ${managedBean}.selected${entityName} or ${managedBean}.${entityName?uncap_first}Editable${r"}"}"/>

                            <p:commandButton id="${entityName}_listForm_refreshBtn" icon="fa fa-refresh" title="${r"#{"}${bundle}.Refresh${r"}"}" actionListener="${r"#{"}${managedBean}.refresh${r"}"}" 
                                             update="${entityName}_listForm_btnsPanel ${entityName}_listForm_dataTable"
                                             disabled="${r"#{"}${managedBean}.${entityName?uncap_first}Editable${r"}"}"/>

                            <p:commandButton id="${entityName}_listForm_excelBtn" ajax="false" icon="fa fa-file-excel-o" title="${r"#{"}${bundle}.Excel${r"}"}" disabled="${r"#{"}${managedBean}.${entityName?uncap_first}Editable${r"}"}">
                                <p:dataExporter type="xls" target="${entityName}_listForm_dataTable" fileName="Items" />
                                </p:commandButton>
                            <p:commandButton id="${entityName}_listForm_pdfBtn" ajax="false" icon="fa fa-file-pdf-o" title="${r"#{"}${bundle}.Pdf${r"}"}" disabled="${r"#{"}${managedBean}.${entityName?uncap_first}Editable${r"}"}">
                                <p:dataExporter type="pdf" target="${entityName}_listForm_dataTable" fileName="Items" />
                                </p:commandButton>
                            </p:outputPanel>	
                        </f:facet>
                    </p:dataTable>
                </p:panel>
            </h:form>
        <h:form id="${entityName}_editForm">
            <h:panelGroup id="${entityName}_editForm_display" rendered="${r"#{"}${managedBean}.selected${entityName} != null${r"}"}">
                <div class="ui-g">
                    <#list entityDescriptors as entityDescriptor>
                        <#if entityDescriptor.id != "id" && entityDescriptor.id != "version">
                        <div class="ui-g-12 ui-md-6 ui-lg-4">
                                <p:outputLabel styleClass="template-labels" 
									value="${r"#{"}${bundle}.${entityDescriptor.id?replace(".","_")}${r"}"}" for="@next" />
                            <#if entityDescriptor.dateTimeFormat?? && entityDescriptor.dateTimeFormat != "">
                            <p:inputMask mask="9999/99/99" id="${entityName}_editForm_${entityDescriptor.id?replace(".","_")}" value="${r"#{"}${managedBean}.selected${entityName}.${entityDescriptor.name?replace("item.","")}${r"}"}" 
                                         converter="JalaliDateConverter" onfocus="serp.showDatePicker(this)" styleClass="PersianDate template-fields" title="${r"#{"}${bundle}.${entityDescriptor.id?replace(".","_")}${r"}"}"
                                         disabled="${r"#{"}!${managedBean}.${entityName?uncap_first}Editable${r"}"}"/>
                            <#elseif entityDescriptor.returnType?matches(".*[Bb]+oolean")>
                            <p:selectBooleanCheckbox styleClass="template-fields" id="${entityName}_editForm_${entityDescriptor.id?replace(".","_")}" 
                                                     value="${r"#{"}${managedBean}.selected${entityName}.${entityDescriptor.name?replace("item.","")}${r"}"}"
                                                     disabled="${r"#{"}!${managedBean}.${entityName?uncap_first}Editable${r"}"}"/>
                            <#elseif entityDescriptor.blob>
                            <p:inputTextarea styleClass="template-fields" id="${entityName}_editForm_textArea" rows="4" cols="30" id="${entityDescriptor.id?replace(".","_")}" 
                                             value="${r"#{"}${entityDescriptor.name}${r"}"}" title="${r"#{"}${bundle}.${entityDescriptor.id?replace(".","_")}${r"}"}"
                                             disabled="${r"#{"}!${managedBean}.${entityName?uncap_first}Editable${r"}"}"/>
                            <#elseif entityDescriptor.relationshipOne>
                            <p:selectOneMenu styleClass="template-fields" id="${entityName}_editForm_${entityDescriptor.id?replace(".","_")}" value="${r"#{"}${managedBean}.selected${entityName}.${entityDescriptor.name?replace("item.","")}${r"}"}"
                                             disabled="${r"#{"}!${managedBean}.${entityName?uncap_first}Editable${r"}"}">
                                <f:selectItem itemLabel="${r"#{"}${bundle}.SelectOneMessage${r"}"}"/>
                                <f:selectItems value="${r"#{"}${entityDescriptor.valuesGetter}${r"}"}" var="${entityDescriptor.id?replace(".","_")}Item" itemValue="${r"#{"}${entityDescriptor.id?replace(".","_")}Item${r"}"}" itemLabel="${r"#{"}${entityDescriptor.id?replace(".","_")}Item.name${r"}"}"/>
                            </p:selectOneMenu>
                            <#elseif entityDescriptor.relationshipMany>
                            <p:selectManyMenu styleClass="template-fields" id="${entityName}_editForm_${entityDescriptor.id?replace(".","_")}" value="${r"#{"}${entityDescriptor.name}${r"}"}"
                                              disabled="${r"#{"}!${managedBean}.${entityName?uncap_first}Editable${r"}"}">
                                <f:selectItems value="${r"#{"}${entityDescriptor.valuesGetter}${r"}"}" var="${entityDescriptor.id?replace(".","_")}Item" itemValue="${r"#{"}${entityDescriptor.id?replace(".","_")}Item${r"}"}"/>
                            </p:selectManyMenu>
                            <#elseif entityDescriptor.id != "id" && entityDescriptor.id != "version">
								<#if entityDescriptor.returnType?matches(".*BigDecimal")>
									<p:inputNumber id="${entityName}_editForm_${entityDescriptor.id?replace(".","_")}" value="${r"#{"}${managedBean}.selected${entityName}.${entityDescriptor.name?replace("item.","")}${r"}"}" title="${r"#{"}${bundle}.${entityDescriptor.id?replace(".","_")}${r"}"}"
									styleClass="inputTxt-template template-fields" decimalPlaces="10" padControl="false"
									disabled="${r"#{"}!${managedBean}.${entityName?uncap_first}Editable${r"}"}"/>
								<#elseif entityDescriptor.returnType?matches(".*Integer") || entityDescriptor.returnType?matches(".*Long")>
									<p:inputNumber id="${entityName}_editForm_${entityDescriptor.id?replace(".","_")}" value="${r"#{"}${managedBean}.selected${entityName}.${entityDescriptor.name?replace("item.","")}${r"}"}" title="${r"#{"}${bundle}.${entityDescriptor.id?replace(".","_")}${r"}"}"
									styleClass="inputTxt-template template-fields" decimalPlaces="0" padControl="false"
									disabled="${r"#{"}!${managedBean}.${entityName?uncap_first}Editable${r"}"}"/>
								<#else>
									<p:inputText id="${entityName}_editForm_${entityDescriptor.id?replace(".","_")}" value="${r"#{"}${managedBean}.selected${entityName}.${entityDescriptor.name?replace("item.","")}${r"}"}" title="${r"#{"}${bundle}.${entityDescriptor.id?replace(".","_")}${r"}"}"
									styleClass="inputTxt-template template-fields"
									disabled="${r"#{"}!${managedBean}.${entityName?uncap_first}Editable${r"}"}"/>
								</#if>
                            </#if>
                        </div>
                        </#if>
                    </#list>
                    </div>
					<p:outputPanel rendered="${r"#{"}${managedBean}.selected${entityName} != null and ${managedBean}.${entityName?uncap_first}Editable${r"}"}"
								   styleClass="saveCancelBtnPanel">
						<p:commandButton id="${entityName}_editForm_save" 
									 actionListener="${r"#{"}${managedBean}${r".save(false)}"}" 
									 styleClass="editForm-btns" icon="fa fa-save"
									 title="${r"#{"}${bundle}.save${r"}"}"
									 update="${entityName}_editForm :${entityName}_listForm:${entityName}_listForm_dataTable" />
						<p:commandButton id="${entityName}_editForm_saveAndCreate" 
									 actionListener="${r"#{"}${managedBean}${r".save(true)}"}" 
									 styleClass="editForm-btns" icon="ui-icon-add-to-photos"
									 title="${r"#{"}${bundle}.saveAndCreate${r"}"}"
									 update="${entityName}_editForm :${entityName}_listForm:${entityName}_listForm_dataTable" />
						<p:commandButton actionListener="${r"#{"}${managedBean}${r".cancel}"}"
									 styleClass="editForm-btns" immediate="true" icon="ui-icon-cancel"
									 title="${r"#{"}${bundle}.cancel${r"}"}"
									 update="${entityName}_editForm :${entityName}_listForm:${entityName}_listForm_dataTable" />
					</p:outputPanel>
            </h:panelGroup>
        </h:form>
        <ui:include src="/general/DeleteConfirmDialog.xhtml"/>
        </ui:define>
    </ui:composition>