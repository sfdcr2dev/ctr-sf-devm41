({
    doInit : function(component, event, helper) {
        helper.initializeCheckboxCommittees(component)
        helper.updateParentCheckbox(component)        
        helper.updateSelectedCommittees(component)
    },
    handleToggleSection: function (component, event, helper) {
        const sectionId = event.currentTarget.getAttribute('data-id');
        const sectionDiv = document.getElementById(sectionId);
        const sectionState = sectionDiv.getAttribute('class').search('slds-is-open');

        if (sectionState == -1) {
            sectionDiv.classList.add('slds-is-open');
        } else {
            sectionDiv.classList.remove('slds-is-open');
        }
    },
    handleChangeParentCheckbox: function (component, event, helper) {
        const el = event.target
        const isChecked = el.checked
        const parentName = el.dataset.parent
        const _groupedCommittees = component.get("v._groupedCommittees")

        const filteredGroup = _groupedCommittees.find((item) => item.parent === parentName)
        if (filteredGroup) {
            filteredGroup.committees.forEach((item) => {
                if (!item.disabled) {
                    item.checked = isChecked
                }
            })
            filteredGroup.checked = isChecked
            component.set("v._groupedCommittees", _groupedCommittees)
        }

        helper.updateSelectedCommittees(component)
    },
    handleChangeCheckbox: function (component, event, helper) {
        const el = event.target
        const isChecked = el.checked
        const parentName = el.dataset.parent
        const committeeName = el.dataset.committee
        const _groupedCommittees = component.get("v._groupedCommittees")

        const filteredGroup = _groupedCommittees.find((item) => item.parent === parentName)
        if (filteredGroup) {
            const committee = filteredGroup.committees.find((item) => item.DeveloperName === committeeName)
            if (committee) {
                committee.checked = isChecked
            }
        }

        helper.updateParentCheckbox(component)
        helper.updateSelectedCommittees(component)
    },
})