import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';

export default class Etb_ListAccountsMultiSite extends OmniscriptBaseMixin(LightningElement) {
    @api cartType;
    @api contextId;
    @api cartId;
    @api opportunityName = 'OportunidadEspecial-Triggered.123456789';
    @track showDatos = false;       //agregarlo al finalizar de llenar los datos
    @track showGroup = false;
    @track showGroupIcon = false;
    @track showUngroup = false;
    @track context;                 //all data
    @track showModal = false;
    @track modalButtonSaveDis = true;
    @track showItemsGroup = false;
    @track showSpinnerGroup = false;
    @track rootLevelFlagShowGroups =  true;
    @track showSpinnerAllTable = true;
    _ns = getNamespaceDotNotation();

    initialContext = {
        fieldList: [],
        filterFieldList: [],
        ungroupedItemList: [],
        groupList: [],
        filters: {},
        sortByString: '',
        ungroupedItemSelected: 0,
        groupedItemSelected: 0,
        groupSelected: 0,
        filterApplicable: {
            group: false
        },
        numberOfFiltersApplied: 0,
        selectedAll: false,
        unGroupedMemberTotalCount: 0,
        showFilter: false
    }

    memberTypeLists = [];
    groupObjectContext = {};

    /*
    * pagination data.
    */
    memberPagination = {
        offset: 0,
        pageSize: 20
    }
    groupPagination = {
        offset: 0,
        pageSize: 20
    }
    ungroupedMemberPagination = {
        offset: 0,
        pageSize: 20
    }

    get unGroupedMemberTotalCountGet(){
        return this.context?.unGroupedMemberTotalCount;
    }

    get groupedItemSelectedGet(){
        return this.context?.groupedItemSelected > 0? true: false;
    }

    get groupSelectedGet(){
        return this.context?.groupSelected > 0? true: false;
    }

    get ungroupedItemSelectedGet(){
        return this.context?.ungroupedItemSelected > 0? true: false;
    }

    get labelUngrupedItemSelectedGet(){
        return this.groupedItemSelectedGet ? false: true;
    }

    get displayCreateGroupGet(){
        return (this.context?.ungroupedItemSelected == 0 && this.context?.groupedItemSelected === 0 && this.context?.groupSelected === 0) || !this.showGroup? true: false;
    }

    get displaySpinner(){
        return this.context?.showTableLoading? true: false;
    }

    get showButtonsStep(){
        console.log('showButtonsStep',!this.context?.showTableLoading && this.context?.unGroupedMemberTotalCount > this.context?.ungroupedMemberPagination.pageSize);
        console.log(this.context);
        return !(this.context?.showTableLoading && this.context?.unGroupedMemberTotalCount > this.context?.ungroupedMemberPagination.pageSize);
    }

    get disabledButtonNext(){
        console.log('disabledButtonNext',!this.context?.haveGroupWithMember);
        return !this.context?.haveGroupWithMember;
    }

    get noData(){
        return !this.showUngroup && !this.showGroup;
    }

    connectedCallback(){
        console.log(this.contextId + ' - ' + this.cartId);
        this.getMemberTypeList();
    }

    showHideGroup = function(evt){
        let evalbtn = (evt.target.dataset.show === 'true');
        this.rootLevelFlagShowGroups = evalbtn;
        evt.target.className = 'slds-button slds-button_brand';
        this.template.querySelector(`[data-show=${!evalbtn}]`).className = 'slds-button slds-button_neutral';
    }

    openCloseModal = function(){
        this.showModal = this.showModal == true ? false : true;
        return this.showModal;
    }

    changeShowGroup = function(evt){
        let i = evt.target.dataset.item;
        this.showGroupIcon = this.showGroupIcon == true? false: true;
        console.log(this.showGroupIcon);
        if(!this.context.groupList[i]?.showItems){            
            evt.target.iconName = 'utility:chevrondown';
            console.log('if', evt.target.iconName);
            console.log('if', this.context.groupList[i].showItems);
        }
        else{
            evt.target.iconName = 'utility:chevronright';
            console.log('else', evt.target.iconName);
            console.log('else', this.context.groupList[i].showItems);
        }

        this.handleViewItemsGroup(evt, false);
    }

    selecAllUngroupedItem = function(evt) {
        let isSelected = evt.target.checked;
        console.log(isSelected);
        var i;
        if(isSelected === undefined) {
            return;
        }
        if(this.context.ungroupedItemList) {
            this.context.ungroupedItemSelected = 0;
            for(i=0; i<this.context.ungroupedItemList.length; i++) {
                this.context.ungroupedItemList[i].isSelected = isSelected;
                if(isSelected) {
                    this.context.ungroupedItemSelected++;
                }
            }
        }
    }

    getMemberTypeList = function() {
        this.fireRemoteAction('getMemberTypeList', {}, {}, function(result, that) {
            let res = result;
            console.log(res);

            if(res.message)
            {
                console.log('error ' + res.message);
                return;
            }
            let memberTypeList = res.result.result;
            
            let groupObj, i;
            
            that.memberTypeLists = [];

            for(i=0; i< memberTypeList.length; i++) {
                groupObj = {
                    label: memberTypeList[i].MasterLabel.toString(),
                    name:  memberTypeList[i][`vlocity_cmt.MemberObjectName__c`],
                    quoteMemberFieldName: memberTypeList[i][`vlocity_cmt.QuoteMemberFieldName__c`],
                    orderMemberFieldName: memberTypeList[i][`vlocity_cmt.OrderMemberFieldName__c`],
                    developerName: memberTypeList[i].DeveloperName
                };
                // groupObj
                if(memberTypeList[i].MasterLabel == "Premises")
                    that.memberTypeLists.push(groupObj);
                that.groupObjectContext[memberTypeList[i].DeveloperName]  = {...that.initialContext};
                that.groupObjectContext[memberTypeList[i].DeveloperName].memberType = memberTypeList[i].DeveloperName;
                that.groupObjectContext[memberTypeList[i].DeveloperName].ungroupedMemberPagination = {...that.ungroupedMemberPagination};
                that.groupObjectContext[memberTypeList[i].DeveloperName].groupPagination = {...that.groupPagination};
            }
            console.log(that.memberTypeLists);
            let developerName = that.groupObjectContext['Premises'].memberType;
            that.context = that.groupObjectContext[developerName];
            let getg = that.getGroups(that.context);
            let getu = that.getUngroupedRecords(that.context);
            let getf = that.getFieldList(that.context);
            Promise.all([getg, getu, getf]).then(r => {
                console.log('resultado ' , r);
                console.log('se ha ejecutado ambas');
                console.log(that.context);
                that.showSpinnerAllTable = false;
                that.showDatos = true;
            });
        });
    }

    getGroups = async function(context){
            context.isGroupsLoading = true;
            var input = {
                parentId: this.contextId,
                contextId: this.cartId,
                pageSize: context.groupPagination.pageSize,
                offset: context.groupPagination.offset,
                memberType: context.memberType
            };
            console.log(this.contextId);
            console.log(input);
            this.fireRemoteAction('getGroups', input, {}, function(result, that){
                context.groupList = [];
                context.groupedItemSelected = 0;
                context.groupSelected = 0;

                let groupedRecords = result.result;
                console.log('getgroups');
                console.log(groupedRecords);
                if(groupedRecords && groupedRecords.message?.length > 0) {
                    that.showNotification('Ha ocurrido un error al obtener los grupos', '', 'error');
                    console.log('error ' + groupedRecords.message);
                }
                if(groupedRecords && groupedRecords.records) {
                    context.groupList = groupedRecords.records;

                    if (context.groupList) {
                        // for (let iDx = 0; iDx < context.groupList.length; iDx++) {
                        //     setMessageAtGroup(context.groupList[iDx]);
                        // }
                        context.groupList.every(o => o.itemsCount > 0) ? context.haveGroupWithMember = true : context.haveGroupWithMember = false;
                    }

                    if(groupedRecords.actions) {
                        context.nextGroupsAction = groupedRecords.actions.nextGroups;
                    }
                    if(groupedRecords.data && groupedRecords.data.groupTotalCount) {
                        context.groupTotalCount = groupedRecords.data.groupTotalCount;7
                    }
                    
                }
                context.isGroupsLoading = false;
                that.context = context;
                if(that.context.groupList?.length > 0)
                    that.showGroup = true;
                else{
                    that.showGroup = false;
                }
            });
        };

    getUngroupedRecords = async function(context) {
        context.showTableLoading = true;
        var input = {
            parentId: this.contextId,
            contextId: this.cartId,
            offset: context.ungroupedMemberPagination.offset, 
            pageSize: context.ungroupedMemberPagination.pageSize,
            memberType: context.memberType
        };
        // var filters = getFilters(context);

        // if(filters) {
        //     input.filters = filters;
        // }
        if(context.sortByString !== '') {
            input.sortBy = context.sortByString;
        }
        if(context.filterApplicable && context.filterApplicable.group) {
            input.applyFiltersOnGroupedItems = true;
        }
        this.fireIP('etb_ServicePremisesMulti', input, function(result,that){ /* VERIFICAR ESTA LINEA PARA USAR EL CORRECTO, ANTES  fireRemoteAction*/
            context.selectedAll = false;
            context.ungroupedItemSelected = 0;
            context.ungroupedItemList = [];
            context.unGroupedMemberTotalCount = 0;
            let ungroupedRecords = result.result.IPResult.result;

            console.log('ungroupedRecords');
            console.log(ungroupedRecords);
            //check for message
            if(ungroupedRecords && ungroupedRecords.message?.length > 0) {
                that.showNotification('Ha ocurrido un error al obtener los items', '', 'error');
                console.error(ungroupedRecords.message);
            }
            if(ungroupedRecords && ungroupedRecords.records) {
                ungroupedRecords.records.forEach(o => {
                    o.Name.value = o.Name.value.replace('- ','');
                });
                context.ungroupedItemList = ungroupedRecords.records;
                /* USAR LO COMENTADO CUANDO SE DEJE DE USAR ESTE IP PARA FILTRAR */
                // if(ungroupedRecords.data && ungroupedRecords.data.totalCount) {
                //     context.unGroupedMemberTotalCount = ungroupedRecords.data.totalCount;
                // }
                if(ungroupedRecords.records && ungroupedRecords.records?.length) {
                    context.unGroupedMemberTotalCount = ungroupedRecords.records.length;
                }
            }
            context.showTableLoading = false;
            that.context = context;
                
            if(that.context.ungroupedItemList?.length > 0)
                that.showUngroup = true;
            else
                that.showUngroup = false;
        });
    }

    getGroupMembers = function(context, group, silentUpdate, customPageSize) {
        console.log('value ', group.showItems);
        if(!silentUpdate) {
            console.log('silentUpdate ', group.showItems);
            group.showItems = !group.showItems;
        }
        if(!group.showItems) {
            console.log('return');
            console.log('value ', group.showItems);
            return;
        }
        if(group.itemsCount == 0 || (!silentUpdate && group.members && group.members.length > 0)) {
            return;
        }
        if(!silentUpdate) {
            group.isLoading = true;
        }
        
        // var filters;
        // if(context && context.filterApplicable.group) {
        //     filters = getFilters(context);
        // }

        if(group.actions) {
            
            let memberAction = group.actions.getGroupMembers;
            if(memberAction && memberAction?.remote && memberAction?.remote?.params && memberAction != undefined) {
                console.log('lo hizo');
                memberAction.remote.params.pageSize = this.memberPagination.pageSize;
                if(customPageSize && !isNaN(customPageSize)) {
                    memberAction.remote.params.pageSize = customPageSize;
                }
                // if(filters) {
                //     memberAction.remote.params.filters = filters;
                // }
                if(context && context.sortByString !== '') {
                    memberAction.remote.params.sortBy = context.sortByString;
                }
            }else
                return;
        }
        

        this.fireAction(group.actions.getGroupMembers, function(result, that) {
            let res = result.result;
            let action;
            if(res) {
                group.members = res.records;
                if(group.members) {
                    for(let i=0; i<group.members.length; i++) {
                        group.members[i].applyToGroup = group.applyToGroup;
                        group.members[i].priceValidate = group.priceValidate;
                        // setMessageAtMember(group.members[i]);
                    }
                    that.showItemsGroup = true;
                }
                if(res.actions) {
                    action = res.actions.getGroupMembers;
                }
            }
            group.actions.getGroupMembers = action;
            group.isLoading = false;
        });
    }

    getFieldList = async function(context) {
        var input = {
            parentId: this.contextId,
            contextId: this.cartId,
            memberType: context.memberType
        }
        this.fireRemoteAction('getDisplayFieldList', input, {}, function(result) {
            var res = result;
            if(res.message) {
                console.log(res.message);
                //$scope.toast(res.message, undefined, 'error');
            } else {
                context.fieldList = res.result.result.filter(o => o.fieldAPIName != "vlocity_cmt__PremisesType__c" && o.fieldAPIName != "vlocity_cmt__ActivationDate__c" && o.fieldAPIName != "vlocity_cmt__PremisesIdentifier__c").sort((a,b) => a.displaySequence - b.displaySequence);
                context.fieldList.filter(o => o.fieldAPIName === 'Name') ? context.fieldList.filter(o => o.fieldAPIName === 'Name')[0].fieldLabel = 'Nombre' : '';
            }
        });
    }

    ungroupedItemSelectionChange = function(evt) {
        console.log('hizo click ungroupedItemSelectionChange');
        let i = evt.target.dataset.item;
        console.log(i);
        let ungroupedItem = this.context.ungroupedItemList[i];
        ungroupedItem.isSelected = evt.target.checked;
        console.log(ungroupedItem);
        if(!ungroupedItem) {
            return;
        }
        
        if(ungroupedItem.isSelected) {
            this.context.ungroupedItemSelected++;
        } else {
            this.context.ungroupedItemSelected--;
        }
        console.log(this.context.ungroupedItemSelected);
    }

    groupedItemSelectionChange = function(evt) {
        console.log('hizo click groupedItemSelectionChange');
        let i = evt.target.dataset.index;
        let mindex = evt.target.dataset.mindex;
        console.log(i);
        console.log(mindex);

        let groupedItem = this.context.groupList[i]?.members[mindex];

        if(!groupedItem) {
            return;
        }else{
            groupedItem.isSelected = evt.target.checked;
            console.log(groupedItem);
        }
        
        if(groupedItem.isSelected) {
            this.context.groupedItemSelected++;
        } else {
            this.context.groupedItemSelected--;
        }
        console.log(this.context.groupedItemSelected);
    }

    groupSelectionChange = function(evt) {

        console.log('hizo click groupSelectionChange');
        let i = evt.target.dataset.item;
        console.log(i);
        let group = this.context.groupList[i];
        group.isSelected = evt.target.checked;
        console.log(group);
        if(!group){
            return;
        }
        if(group.isSelected) {
            this.context.groupSelected++;
        } else {
            this.context.groupSelected--;
        }

        if(!group?.members) {
            console.log('salio');
            return;
        }
        let records = group?.members;

        if(!records) {
            return;
        }
   
        for(let i=0; i < records.length; i++) {

            if(!records[i].isSelected && group.isSelected) {
                this.context.groupedItemSelected++;
            } else if(records[i].isSelected && !group.isSelected && this.context.groupedItemSelected > 0){
                this.context.groupedItemSelected--;
            }
            records[i].isSelected = group.isSelected;
        }
    }

    onChangeGroupName = function(evt){
        let name = evt.target.value;
        console.log(name);
        if(!name)
            this.modalButtonSaveDis = true;
        else
            this.modalButtonSaveDis = false;
    }

    createNewGroup = function(evt) {
        console.log('creando nuevo grupo');
        this.showNotification(`Creando el grupo...`, '', 'info');
        let name = this.template.querySelector('[data-id="newGroupName"]').value;
        let description = this.template.querySelector('[data-id="newGroupDescription"]').value;
        console.log(name);
        this.saveNewGroup(name, description);
    }

    handleAddToGroup = function(evt){
        let i = evt.target.dataset.item;
        this.showNotification(`Agregando a ${this.context.groupList[i].groupName}`, '', 'info');
        this.addToGroup(this.context, this.context.groupList[i]);
    }

    handleViewItemsGroup = function(evt){
        let i = evt.target.dataset.item;
        this.getGroupMembers(this.context, this.context.groupList[i]);
    }

    handleDeleteMember = function(evt){
        this.showNotification(`Eliminando item(s) del grupo...`, '', 'info');
        this.deleteMembers(this.context);
    }

    saveNewGroup = function(name, description) {
        let input = {
            groupName: name,
            groupDescription: description,
            parentId: this.contextId,
            contextId: this.cartId,
            memberType: this.context.memberType
        };
        // if($scope.bpTree.response.cartTypeStrategy === 'single' || 
        //     $scope.bpTree.response.selectedCartStrategy === 'single') {
        //     input.isGroupAssociatedWithCart = false;
        // }
        
        this.fireRemoteAction('createNewGroup', input, {}, function(result,that){
            console.log(result);
            let response = result.result;
            if(response) {
                if(response?.message) {
                    that.showNotification(response.message, '', 'error');
                    console.log('error');
                    console.error(response.message);
                } else {
                    that.modalButtonSaveDis = true;
                    that.openCloseModal();
                    that.showNotification(`El grupo ${name} se ha creado con éxito.`, '', 'success');
                    that.addToGroup(that.context, response.groupInfo, true);
                }
            }
            
        });
    }

    addToGroup = function(context, group, reload) {

        let selectedIds = [], i;
        for(i=0; i<context.ungroupedItemList.length; i++) {
            if(context.ungroupedItemList[i].isSelected)
            {
                selectedIds.push(context.ungroupedItemList[i].Id.value); 
            }
        }
        if(selectedIds.length === 0 || !group) {
            if(reload) {
                this.getUngroupedRecords(context);
                this.getGroups(context);
            }
            return;
        }
        let groupInfo = {};
        groupInfo['servicePoints'] = selectedIds;
        console.info('groupInfo ');
        console.info(groupInfo);
        let input = {
            groupId: group.groupId,
            groupCartId: group.groupCartId,
            groupName: group.groupName,
            parentId: this.contextId,
            contextId: this.cartId,
            groupJSON: groupInfo,
            memberType: context.memberType
        };
        // let addingToast = $scope.toast($scope.customLabelsMap.MSAddingToMsg + ' ' + group.groupName + '...', undefined, 'info');
        this.fireRemoteAction('addToGroup', input, {}, function(result, that){
            that.getUngroupedRecords(context);
            that.getGroups(context);
            that.closeAllGroups(context);
            console.info('addToGroup ', result);
            let response = result.result;
            if(response && response.message?.length > 0) {
                that.showNotification(response.message, '', 'error');
                console.error(response.message);
            } else {
                that.showNotification( `Agregando a ${group.groupName}`,'', 'success');
                console.info('success addToGroup');
            }
            // $scope.bpTree.randomCount++;
        });
    }

    deleteGroups = function(evt) {
        let groupIds = [], i;
        let selectedGroupNames = '';
        for(i=0; i<this.context.groupList.length; i++) {
            if(this.context.groupList[i].isSelected) {
                groupIds.push(this.context.groupList[i].groupId);
                selectedGroupNames += this.context.groupList[i].groupName + '<br>';
            }
        }
        // if(groupIds.length > 0) {
        //     $scope.alertBox($scope.customLabelsMap.MSDeleteGroupsLabel, 
        //         $scope.customLabelsMap.MSSeletectedGroupsToDeleteLabel+'<p><ul><li>'+selectedGroupNames+'</li></ul></p>',
        //         $scope.customLabelsMap.MSDeleteGroupsLabel, deleteGroupsCB, context, groupIds);
        // }
        this.showNotification(`Eliminando grupo(s)...`, '', 'info');
        this.deleteGroupsCB(this.context, groupIds);
    }

    deleteGroupsCB = function(context, groupIds) {
        // $scope.toast($scope.customLabelsMap.MSDeletingGroupMsg, undefined, 'info');
        let input = {contextId: this.cartId, groupIds: groupIds};
        this.fireRemoteAction( 'removeGroups', input, {}, function(result, that){
            let response = result.result;
            console.log('removegroups');
            console.log(response);
            if(response.message) {
                that.showNotification(response.message,'', 'error');
                console.error(response.message);
            } else {
                that.showNotification(`Grupo(s) eliminado(s).`,'', 'success');
                that.getUngroupedRecords(context);
                that.getGroups(context);
            }
            // $scope.bpTree.randomCount++;
        });
    }

    deleteMembers = function(context) {
        console.log('deleteMembers', context);
        let selectedIds = [], i, group, records, j;
        for(i=0; i<context.groupList.length; i++) {
            group = context.groupList[i];
            if(group.members) {
                records = group.members;
                for(j=0; j<records.length; j++) {
                    if(records[j].isSelected){
                        selectedIds.push(records[j].Id.value); 
                    }
                }
            }
        }
        if(selectedIds.length === 0) {
            console.log('return');
            return;
        }
        // $scope.toast($scope.customLabelsMap.MSRemovingItemGroupMsg, undefined, 'info');
        let input = {
            memberIds: selectedIds,
            memberType: context.memberType,
            parentId: this.contextId,
            contextId: this.cartId
        };

        this.fireRemoteAction('deleteMembers', input, {}, function(result, that){
            let allMessages = [], key;
            if(result) {
                result = result.result;
            }
            if(result.messages) {
                for(key in result.messages) {
                    allMessages.push(result.messages[key]);
                }
                that.showNotification(allMessages.join('\n'), '', 'error');
                console.log('error: ', allMessages.join('\n'));
            } else {
                that.showNotification(`Se ha sacado del grupo de manera exitosa.`,'', 'success');
                console.log('success: ');
            }
            
            that.getUngroupedRecords(context);
            that.getGroups(context);
            that.closeAllGroups(context);
            // that.bpTree.randomCount++;
        });
    }

    closeAllGroups = function(context){
        context.groupList?.forEach((o, i) => {
            console.log(i);
            this.template.querySelector(`lightning-icon[data-item="${i}"]`).iconName = 'utility:chevronright';
        });
    }

    showNotification = function(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
            //mode: 'pester'
        });
        this.dispatchEvent(evt);
    }

    previousPage = function(){
        console.log('previous page');
        this.omniPrevStep();
    }

    nextPage = function(){
        console.log('next page');
        this.omniNextStep();
    }

    /* class apex vlocity */
    fireRemoteAction = function(methodName, input, options, callBackFn) {
        input.cartType = this.cartType;
        let remoteActionObj = {
            sClassName: `${this._ns}MultiServiceAppHandler`,
            sMethodName: methodName,
            input: JSON.stringify(input),
            options: JSON.stringify(options),
            iTimeout: 30000                
        };
        console.log(remoteActionObj);
        this.omniRemoteCall(remoteActionObj, false).then((response) => {
            callBackFn(response, this);
        });
    }

    fireIP = function(name, input, callBackFn) {
        if(name === '') {
            return;
        }
        let configObj = {
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: name,
            input: JSON.stringify(input),
            options: JSON.stringify({}),
            iTimeout: 30000
        };
        this.omniRemoteCall(configObj).then((response) => {
            callBackFn(response, this);
        });
    }

    fireDR = function(bundle, params, callBackFn) {
        if(bundle === '') {
            return;
        }
        let input = {
            "DRParams": params,
            "Bundle": bundle
        }
        let configObj = {
            sClassName: `${this._ns}DefaultDROmniScriptIntegration`,
            sMethodName: "invokeOutboundDR",
            input: JSON.stringify(input),
            options: JSON.stringify({}),
            iTimeout: 30000
            //label: { label: element && element.name }
        };
        this.omniRemoteCall(configObj).then((response) => {
            callBackFn(response);
        });
    }

    fireAction = function(action, callBackFn) {
        if(!action.remote || !action.remote.params) {
            return;
        }

        let params = action.remote.params;
        let input = {}, key;
        for(key in params) {
            if(key !== 'methodName') {
                input[key] = params[key];
            }
        }
        return this.fireRemoteAction(params.methodName, input, {}, callBackFn);
    }
}