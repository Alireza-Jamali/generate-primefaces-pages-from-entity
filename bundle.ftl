<#if comment>

  TEMPLATE DESCRIPTION:

  This is Bundle.properties template for 'JSF Pages From Entity Beans' action. Templating
  is performed using FreeMaker (http://freemarker.org/) - see its documentation
  for full syntax. Variables available for templating are:

    comment - always (Boolean; always FALSE)
    projectName - display name of the project (type: String)
    entities - list of beans with following properites:
        entityClassName - controller class name (type: String)
        entityDescriptors - list of beans describing individual entities. Bean has following properties:
            label - part of bundle key name for label (type: String)
            title - part of bundle key name for title (type: String)
            name - field property name (type: String)
            dateTimeFormat - date/time/datetime formatting (type: String)
            blob - does field represents a large block of text? (type: boolean)
            relationshipOne - does field represent one to one or many to one relationship (type: boolean)
            relationshipMany - does field represent one to many relationship (type: boolean)
            id - field id name (type: String)
            required - is field optional and nullable or it is not? (type: boolean)
            valuesGetter - if item is of type 1:1 or 1:many relationship then use this
                getter to populate <h:selectOneMenu> or <h:selectManyMenu>

  This template is accessible via top level menu Tools->Templates and can
  be found in category JavaServer Faces->JSF from Entity.

</#if>
PersistenceErrorOccured=ارور persistency رخ داد.
Create=جدید
View=نمایش
Edit=ویرایش
Delete=حذف
Close=بستن
Cancel=بی خیالش
Save=ذخیره
SelectOneMessage=انتخاب کنید...
Home=صفحه اصلی
Maintenance=تعمیرات
AppName=${projectName?replace("AutoGen", "")}

<#list entities as entity>
Created=اطلاعات جدید با موفقیت ثبت شد.
Updated=به روز رسانی با موفقیت انجام شد.
Deleted=عملیات حذف با موفقیت انجام شد.
	
Empty= اطلاعات مورد نظر یافت نشد.
DestroyLink=حذف
EditLink=ویرایش
ViewLink=نمایش
CreateLink=ساخت لینک جدید
IndexLink=شماره

ConfirmDialog_yes=تایید
ConfirmDialog_no=عدم تایید
ConfirmDialog_title=تاییدیه
ConfirmDialog_message=آیا برای حذف مطمئن هستید ؟

    <#list entity.entityDescriptors as entityDescriptor>
Title_${entityDescriptor.id?replace(".","_")}=${entityDescriptor.label}
    </#list>
</#list>







EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE=EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE







PersistenceErrorOccured=A persistence error occurred.
Create=Create
View=View
Edit=Edit
Delete=Delete
Close=Close
Cancel=Cancel
Save=Save
SelectOneMessage=Select One...
Home=Home
Maintenance=Maintenance
AppName=${projectName?replace("AutoGen", "")}

<#list entities as entity>
Created=${entity.entityClassName} was successfully created.
Updated=${entity.entityClassName} was successfully updated.
Deleted=${entity.entityClassName} was successfully deleted.
	
Title=List
Empty=(No ${entity.entityClassName} Items Found)
DestroyLink=Destroy
EditLink=Edit
ViewLink=View
CreateLink=Create New ${entity.entityClassName}
IndexLink=Index
    <#list entity.entityDescriptors as entityDescriptor>
Title_${entityDescriptor.id?replace(".","_")}=${entityDescriptor.label}
    </#list>
</#list>
