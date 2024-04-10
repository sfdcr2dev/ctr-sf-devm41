({
    onInit: function (component, event, helper) {

        helper.getPicklistValuesSoftwareAsset(component, event, helper)
        helper.getCaseLineItemRecordTpyeInfoes(component)
    },
    handleITAssetOwner: function (component, event, helper) {
        helper.getPicklistValuesITAsset(component)
    },
    handleLoad: function (component, event, helper) {
        var recordUi = event.getParam('recordUi')
        component.set('v.recordUi', recordUi)

        // component.set('v.recordTypeId',
        //     Object.keys(component.get('v.recordUi.objectInfo.recordTypeInfos'))
        //         .find(recordTypeId => {
        //             return component.get(`v.recordUi.objectInfo.recordTypeInfos.${recordTypeId}.name`) === 'Software - Catalog'
        //         }))

    },
    handleCloseModal: function (component, event, helper) {
        helper.closeModal()
    },
    handleUtilityLwcButton: function (component, event, helper) {
        component.find('utilityLwcButton').submit_click()
    },
    handleSubmit: function (component, event, helper) {
        helper.startSpinner(component)
        // event.preventDefault();
    },
    handleSuccess: function (component, event, helper) {
        component.find('quickActionAPI').refresh()
        helper.closeModal()
    },
    handleError: function (component, event, helper) {
        helper.stopSpinner(component)

    },
})