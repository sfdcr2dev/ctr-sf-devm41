({
    initializeCheckboxCommittees: function (component) {
        const committees = component.get("v.committees")
        const includedCommittees = component.get("v.includedCommittees")
        const selectedCommittees = component.get("v.selectedCommittees")
        
        if (!$A.util.isArray(committees)) {
            return;
        }

        if ($A.util.isArray(includedCommittees)) {
            includedCommittees.forEach((item) => {
                const committee = committees.find((innerItem) => {
                    return innerItem.DeveloperName === item.trim()
                })
                if (committee) {
                    committee.checked = true
                    committee.disabled = true
                }
            })
        }

        if ($A.util.isArray(selectedCommittees)) {
            selectedCommittees.forEach((item) => {
                const committee = committees.find((innerItem) => {
                    return innerItem.DeveloperName === item.trim()
                })
                if (committee) {
                    committee.checked = true
                }
            })
        }

        const _groupedCommittees = [];
        committees.forEach((item) => {
            if (!$A.util.isArray(_groupedCommittees)) {
                _groupedCommittees = []
            }
            const index = _groupedCommittees.findIndex((innerItem) => innerItem.parent === item.Parent__c)
            if (index < 0) {
                _groupedCommittees.push({
                    parent: item.Parent__c,
                    committees: [item],
                })
            } else {
                _groupedCommittees[index].committees.push(item)
            }
        })
        component.set("v._groupedCommittees", _groupedCommittees)
    },
    updateSelectedCommittees: function (component) {
        const _groupedCommittees = component.get("v._groupedCommittees")
        const _selectedCommittees = []
        const _selectedEmailCommittees = []
        _groupedCommittees.forEach((item) => {
            item.committees.forEach((innerItem) => {
                if (innerItem.checked) {
                    _selectedCommittees.push(innerItem.DeveloperName)
                    _selectedEmailCommittees.push(innerItem.Email__c)
                }
            })
        })
        component.set("v.selectedCommittees", _selectedCommittees)
        component.set("v.selectedEmailCommittees", _selectedEmailCommittees)
    },
    updateParentCheckbox: function (component) {
        const _groupedCommittees = component.get("v._groupedCommittees")
        _groupedCommittees.forEach((item) => {
            let isAllChecked = true
            item.committees.forEach((innerItem) => {
                isAllChecked = isAllChecked && innerItem.checked
            })
            item.checked = isAllChecked
            let isAllDisabled = true
            item.committees.forEach((innerItem) => {
                isAllDisabled = isAllDisabled && innerItem.disabled
            })
            item.disabled = isAllDisabled
        })
        component.set("v._groupedCommittees", _groupedCommittees)
    },
})