<template>
    <c-step-page-header
        num-steps="2"
        current-step="1"
        percentage="{percentage}"
        is-current="{isCurrent}"
        record-id="{recordId}"
    ></c-step-page-header>
    <c-lwc-modal
        title="{modalTitle}"
        is-visible="{modalVisible}"
        confirm-text="{modalConfirmButton}"
        cancel-text="{modalCancelButton}"
        name="{modalName}"
        message="{modalMessage}"
        onselected="{handleModalSelection}"
    ></c-lwc-modal>
    <div class="slds-text-heading_medium text-center">QC WORKSHOP MOTOR INSPECTION FORM</div>
    <section class="section slds-accordion__section">
        <div class="slds-grid slds-gutters">
            <div class="slds-col">
                <label class="slds-form-element__label" for="tank-no">Notification</label>
                <div class="slds-form-element__control slds-input-has-icon slds-input-has-icon_right">
                    <svg
                        class="slds-icon slds-input__icon slds-input__icon_right slds-icon-text-default"
                        aria-hidden="true"
                    >
                        <use xlink:href="/assets/icons/utility-sprite/svg/symbols.svg#search"></use>
                    </svg>
                    <input type="text" data-id="notification" class="slds-input" value="{notification}" disabled />
                </div>
                <div class="slds-col slds-size_6-of-12 slds-medium-size_6-of-12 slds-large-size_6-of-12"></div>
            </div>
            <div class="slds-col">
                <label class="slds-form-element__label" for="tank-no">FL.</label>
                <div class="slds-form-element__control">
                    <input type="text" data-id="fl" class="slds-input" value="{functionalLocation}" disabled />
                </div>
                <label class="slds-form-element__label" for="tank-no">Status</label>
                <div class="slds-form-element__control">
                    <input type="text" data-id="status" class="slds-input" value="{formStatus}" disabled />
                </div>
            </div>
        </div>
    </section>
    <div class="bs-example">
        <ul class="slds-accordion">
            <li class="slds-accordion__list-item">
                <section class="slds-accordion__section slds-is-open" data-id="sectionOne">
                    <div class="card-header" data-id="headingOne">
                        <h2 class="slds-accordion__summary-heading">
                            <button
                                type="button"
                                aria-controls="collapseOne"
                                aria-expanded="true"
                                class="slds-button slds-button_reset slds-accordion__summary-action"
                                data-parent="sectionOne"
                                onclick="{expandSection}"
                            >
                                <lightning-icon
                                    icon-name="utility:switch"
                                    alternative-text="button icon"
                                    size="x-small"
                                    class="slds-accordion__summary-action-icon slds-button__icon slds-button__icon_left"
                                ></lightning-icon>
                                <span
                                    style="background-color: var(--lwc-brandAccessible, rgb(0, 112, 210))"
                                    class="slds-badge slds-badge_inverse"
                                >
                                    0</span
                                ><span class="slds-accordion__summary-content"> Header Information</span>
                            </button>
                        </h2>
                    </div>
                    <div data-id="collapseOne" class="slds-accordion__content">
                        <div
                            id="collapseOne"
                            class="collapse"
                            aria-labelledby="headingOne"
                            data-parent="#accordionExample"
                        >
                            <div class="card-body">
                                <div class="slds-grid slds-gutters">
                                    <div class="slds-col">
                                        <label class="slds-form-element__label" for="tank-no">วันที่ (date)</label>
                                        <div class="slds-form-element__control">
                                            <input
                                                onchange="{onIEH}"
                                                type="date"
                                                data-id="0-input-1"
                                                class="slds-input"
                                            />
                                        </div>
                                    </div>
                                    <div class="slds-col">
                                        <label class="slds-form-element__label" for="tank-no">Serial No.</label>
                                        <div class="slds-form-element__control">
                                            <input
                                                onchange="{onIEH}"
                                                type="text"
                                                data-id="0-input-2"
                                                class="slds-input"
                                            />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </li>
            <li class="slds-accordion__list-item">
                <section class="slds-accordion__section slds-is-open" data-id="sectionTwo">
                    <div class="card-header" data-id="headingTwo">
                        <h2 class="slds-accordion__summary-heading">
                            <button
                                type="button"
                                aria-controls="collapseTwo"
                                aria-expanded="true"
                                class="slds-button slds-button_reset slds-accordion__summary-action"
                                data-parent="sectionTwo"
                                onclick="{expandSection}"
                            >
                                <lightning-icon
                                    icon-name="utility:switch"
                                    alternative-text="button icon"
                                    size="x-small"
                                    class="slds-accordion__summary-action-icon slds-button__icon slds-button__icon_left"
                                ></lightning-icon>
                                <span
                                    style="background-color: var(--lwc-brandAccessible, rgb(0, 112, 210))"
                                    class="slds-badge slds-badge_inverse"
                                >
                                    1</span
                                ><span class="slds-accordion__summary-content"> ตรวจสอบทางกายภาพ</span>
                            </button>
                            <div class="slds-col">
                                <div class="slds-checkbox obj-right">
                                    <input
                                        onchange="{disableSection}"
                                        type="checkbox"
                                        data-id="header-na-1"
                                        value="na"
                                        data-parent="sectionTwo"
                                    />
                                    <label class="slds-checkbox__label" for="header-na-1">
                                        <span class="slds-checkbox_faux"></span>
                                        <span class="slds-form-element__label">input N/A</span>
                                    </label>
                                </div>
                            </div>
                        </h2>
                        <div class="slds-grid slds-gutters" style="display: none" data-id="1-remark">
                            <div class="slds-col">
                                <label class="slds-form-element__label" for="tank-no">Remark</label>
                                <div class="slds-form-element__control">
                                    <textarea data-id="1-input-remark" class="slds-textarea"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div data-id="collapseTwo" class="slds-accordion__content">
                        <div
                            id="collapseTwo"
                            class="collapse"
                            aria-labelledby="headingTwo"
                            data-parent="#accordionExample"
                        >
                            <div class="card-body">
                                <div class="table-responsive" style="margin-bottom: 0rem">
                                    <table class="table">
                                        <thead>
                                            <td rowspan="2">
                                                <span class="slds-form-element__label">รายการที่ต้องการตรวจสอบ</span>
                                            </td>
                                            <td colspan="3" class="text-center">
                                                <span class="slds-form-element__label">ผลการตรวจสอบ</span>
                                            </td>
                                            <td rowspan="2" class="text-center pd-0-25">
                                                <span class="slds-form-element__label pd-right-0"
                                                    >วิธีการแก้ไขเมื่อไม่ผ่าน</span
                                                >
                                            </td>
                                            <td colspan="2" class="text-center">
                                                <span class="slds-form-element__label">ผลการแก้ไข</span>
                                            </td>
                                            <tr>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">ผ่าน</span>
                                                </td>
                                                <td class="text-center pd-0">
                                                    <span class="slds-form-element__label">ไม่ผ่าน</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">NA</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">ผ่าน</span>
                                                </td>
                                                <td class="text-center pd-0">
                                                    <span class="slds-form-element__label">ไม่ผ่าน</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label"
                                                        >1. ตรวจสอบทางกายภาพ (Physical inspection before assembly)</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >1.1 สเตเตอร์ (Stator) The number of stator coils</span
                                                    >
                                                    <div class="slds-form-element w-80 pd-left-10">
                                                        <div
                                                            class="slds-form-element__control slds-input-has-fixed-addon"
                                                        >
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="1-1-input"
                                                                class="slds-input"
                                                            />
                                                            <span
                                                                class="slds-form-element__addon slds-form-element__label"
                                                                >coils.</span
                                                            >
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ฉนวนอยู่ในสภาพดี,ไม่ฉีกขาด,ขดลวดสะอาด</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-2-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-2-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-2-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-1-2-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-2-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-2-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- บริเวณรอยบ่าลอยต่อกันฝาครอบด้าน DE &amp; NDE ต้องสะอาด,
                                                        เรียบ, ไม่มีรอย, ขีดข่วน</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-3-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-3-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-3-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-1-3-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-3-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-3-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ฮีตเตอร์ติดตั้งเรียบร้อย, ขันแน่น, เก็บสายไฟเรียบร้อย</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-4-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-4-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-4-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-1-4-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-4-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-4-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- อุปกรณ์วัดอุณหภูมิ RTD ของขดลวดติดตั้งเรียบร้อย,
                                                        ไม่กีดขวาง</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-5-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-5-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-5-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-1-5-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-5-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-5-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- แกนเหล็กไม่เสียหาย, ไม่มีรอยกระแทก, ไม่มีการเยิน</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-6-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-6-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-6-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-1-6-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-6-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-6-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ขดลวดไม่มีการถลอก, ขีดข่วน, กระแทก
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-7-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-7-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-7-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-1-7-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-7-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-1-7-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >1.2 โรเตอร์ (Rotor) The number of rotor bars</span
                                                    >
                                                    <div class="slds-form-element w-80 pd-left-10">
                                                        <div
                                                            class="slds-form-element__control slds-input-has-fixed-addon"
                                                        >
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="1-2-input"
                                                                class="slds-input"
                                                            />
                                                            <span
                                                                class="slds-form-element__addon slds-form-element__label"
                                                                >Bars.</span
                                                            >
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ผิวภายนอกสะอาด, ไม่มีฝุ่น, คราบน้ำมัน</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-1-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-1-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-1-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-2-1-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-1-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-1-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- แกนเหล็กไม่เสียหาย, ไม่มีรอยกระแทก, ไม่มีการเยิน</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-2-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-2-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-2-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-2-2-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-2-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-2-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- โรเตอร์บาร์ไม่แตกร้าว</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-3-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-3-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-3-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-2-3-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-3-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-3-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ใบพัดที่ตัวโรเตอร์สมบูรณ์, ไม่มีการแตกร้าว, ไม่เสียหาย,
                                                        ไม่คดงอ</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-4-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-4-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-4-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-2-4-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-4-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-4-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- จุดใส่น้ำหนักบาลานซ์ไม่มีการหักงอ, ไม่มีการแตกร้าว</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-5-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-5-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-5-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-2-5-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-5-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-5-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- เพลาไม่มีการคดงอ (ตามมาตรฐานที่ MECH W/S แจ้งมา)</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-6-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-6-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-6-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-2-6-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-6-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-6-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ผิวเพลาทั่วไป,ตำแหน่งแบริ่ง ต้องราบเรียบ, ไม่มีการกระแทก,
                                                        ไม่มีการแตกบิ่น, ต้องเป็นมันเงา</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-7-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-7-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-7-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-2-7-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-7-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-7-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ขนาดเพลาตำแหน่งแบริ่ง DE &amp; NDE เป็นไปตามกำหนด
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-8-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-8-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-8-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-2-8-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-8-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-8-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ลิ่มปลายเพลา, ร่องลิ่มไม่หลวม, ไม่เสียหาย, ไม่สึกหรอ
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-9-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-9-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-9-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-2-9-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-9-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-2-9-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >1.3 ฝาครอบด้าน DE &amp; NDE</span
                                                    >
                                                </td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ตรวจสอบตำแหน่งมาร์ค DE = 1 จุด, NDE = 2 จุด ตรงตามตำแหน่ง
                                                        Mark
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-1-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-1-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-1-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-3-1-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-1-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-1-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ไม่มีความเสียหาย, แตกหัก, รอยร้าว</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-2-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-2-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-2-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-3-2-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-2-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-2-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- สะอาด, ไม่มีฝุ่น, คราบน้ำมัน, คราบจารบี</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-3-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-3-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-3-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-3-3-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-3-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-3-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- (Housing) สะอาด, ไม่มีคราบดำ, มันเงา</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-4-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-4-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-4-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-3-4-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-4-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-3-4-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >1.4 ฝาประกับนอกและใน</span
                                                    >
                                                </td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ไม่มีความเสียหาย,ไม่แตกหักหรือมีรอยร้าว, สะอาด</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-1-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-1-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-1-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-4-1-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-1-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-1-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- สภาพหัวอัดจารบีอยูในสภาพใช้งานได้ดี</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-2-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-2-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-2-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-3-6-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-2-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-2-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- รอยต่อที่ประกบกับฝาครอบสะอาด ราบเรียบ</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-3-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-3-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-3-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-4-3-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-3-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-3-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ร่องซีล หรือร่องโอริ่งทำความสะอาดเรียบร้อย
                                                        ไม่มีสิ่งสกปรกแทรกอยู่</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-4-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-4-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-4-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-4-4-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-4-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-4-4-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >1.5 พัดลมและฝาครอบพัดลม</span
                                                    >
                                                </td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ไม่มีความเสียหาย, แตกหัก, รอยร้าว, ไม่มีการบิดเบี้ยว
                                                        เสียรูป</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-1-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-1-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-1-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-5-1-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-1-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-1-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- สภาพแหวนล็อคไม่ผุ, ไม่บิดเบี้ยว</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-2-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-2-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-2-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-5-2-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-2-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-2-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ลิ่มใบพัดใส่ได้ตามขนาดร่อง ไม่หลวม, ไม่เสียหาย, ไม่ขยายกว้าง
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-3-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-3-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-3-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-5-3-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-3-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-5-3-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10">1.6 แบริ่ง</span>
                                                </td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- สภาพแบริ่งต้องไม่มีสนิม หมุนด้วยมือเปล่าคล่อง
                                                        ราบเรียบไม่สะดุด ไม่มีเสียงแปลกปลอม ไม่มีความเสียหาย, แตกหัก,
                                                        รอยร้าว
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-1-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-1-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-1-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-6-1-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-1-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-1-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- NE Bearing</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-2-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-2-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-2-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-6-2-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-2-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-2-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- NDE Bearing</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-3-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-3-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-3-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-6-3-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-3-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-6-3-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >1.7 ซีล, V-ring, Dust seal และโอริง</span
                                                    >
                                                </td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ไม่มีความเสียหาย, บิดเบี้ยว, ฉีกขาด</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-7-1-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-7-1-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-7-1-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-7-1-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-7-1-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-7-1-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >1.8 POT HEAD MOTOR</span
                                                    >
                                                </td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ภายในและภายนอก Box , ฝา Box ต้องสะอาด เรียบร้อย</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-1-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-1-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-1-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-8-1-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-1-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-1-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- Gasket หรือ Seal ต้องอยู่ในสภาพที่ดี</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-2-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-2-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-2-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-8-2-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-2-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-2-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- น็อตยึดฝา box ต้องเป็น Type เดียวกัน
                                                        ขนาดและความยาวเท่ากัน</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-3-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-3-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-3-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-8-3-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-3-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-3-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- Terminal ไม่มีร่องรอยการชำรุด, แตกหัก และหลักยึดต้องไม่หลวม
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-4-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-4-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-4-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-8-4-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-4-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-4-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- Busbar ต้องทำความสะอาด, ไม่มีรอยเกิด Over heat
                                                        และต้องขันยึดแน่น</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-5-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-5-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-5-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-8-5-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-5-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-5-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- Lead cable ฉนวนต้องไม่กรอบ, หรือมีรอย Heat
                                                        และต้องขันยึดแน่นกับ Terminal และ (Lead Cable Size</span
                                                    >
                                                    <div class="slds-form-element w-80 pd-left-10">
                                                        <div
                                                            class="slds-form-element__control slds-input-has-fixed-addon pd-left-10"
                                                        >
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="lead-cable-size"
                                                                class="slds-input"
                                                            />
                                                            <span
                                                                class="slds-form-element__addon slds-form-element__label"
                                                                >sq mm.,) มีขนาดเหมาะสม</span
                                                            >
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-6-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-6-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-6-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-8-6-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-6-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-6-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- Cable lug สภาพดีไม่มีร่องรอยของการหัก งอ หรือรอยเกิด Over
                                                        Heat</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-7-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-7-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-7-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-8-7-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-7-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-7-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >- ตำแหน่ง Pot Head Motor, Cable Gland Entry
                                                        ประกอบถูกต้องตำแหน่งเดิม</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-8-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-8-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-8-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="1-8-8-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-8-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="1-8-8-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10">
                                                        <fieldset class="slds-form-element slds-form-element_compound">
                                                            <div class="slds-form-element__control">
                                                                <div class="slds-form-element__row">
                                                                    <div
                                                                        class="custom-control custom-radio"
                                                                        style="margin-top: 5px"
                                                                    >
                                                                        <input
                                                                            onchange="{onIEH}"
                                                                            type="radio"
                                                                            data-id="1-8-9-radio-1"
                                                                            class="custom-control-input"
                                                                            value="ปกติ"
                                                                        />
                                                                        <label
                                                                            class="custom-control-label slds-form-element__label"
                                                                            for="1-8-9-radio-1"
                                                                            style="margin-top: 0px"
                                                                            ><img
                                                                                src="https://thor--dev4--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0680p000000Sm4f&operationContext=DELIVERY&contentId=05T0p000001qoKT&page=0&d=/a/0p0000008V7R/VGQgW3DGgHGhdHsMEIM.8iN4ryJ03pZBW0qCowQuo10&oid=00D0p0000008gcw&dpt=null&viewId="
                                                                                alt="Girl in a jacket"
                                                                                width="40"
                                                                                height="40"
                                                                        /></label>
                                                                    </div>
                                                                    <div
                                                                        class="custom-control custom-radio"
                                                                        style="margin-top: 5px"
                                                                    >
                                                                        <input
                                                                            onchange="{onIEH}"
                                                                            type="radio"
                                                                            data-id="1-8-9-radio-2"
                                                                            class="custom-control-input"
                                                                            value="ผิดปกติ"
                                                                        />
                                                                        <label
                                                                            class="custom-control-label slds-form-element__label"
                                                                            for="1-8-9-radio-2"
                                                                            ><img
                                                                                src="https://thor--dev4--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0680p000000Sm4L&operationContext=DELIVERY&contentId=05T0p000001qoJp&page=0&d=/a/0p0000008V7H/XmtngXka5rwkUF6oGHQSqAafU95UKKTaQExw.zwjyTE&oid=00D0p0000008gcw&dpt=null&viewId="
                                                                                alt="Girl in a jacket"
                                                                                width="50"
                                                                                height="50"
                                                                        /></label>
                                                                    </div>
                                                                    <div
                                                                        class="custom-control custom-radio"
                                                                        style="margin-top: 5px"
                                                                    >
                                                                        <input
                                                                            onchange="{onIEH}"
                                                                            type="radio"
                                                                            data-id="1-8-9-radio-3"
                                                                            class="custom-control-input"
                                                                            value="ผิดปกติ"
                                                                        />
                                                                        <label
                                                                            class="custom-control-label slds-form-element__label"
                                                                            for="1-8-9-radio-3"
                                                                            ><img
                                                                                src="https://thor--dev4--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0680p000000Sm4V&operationContext=DELIVERY&contentId=05T0p000001qoK4&page=0&d=/a/0p0000008V7M/ljfoONBIVVaTxzuqn_YYvf4IPdy0XE8rIubX87uy0C8&oid=00D0p0000008gcw&dpt=null&viewId="
                                                                                alt="Girl in a jacket"
                                                                                width="50"
                                                                                height="50"
                                                                        /></label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </fieldset>
                                                    </span>
                                                </td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </li>
            <li class="slds-accordion__list-item">
                <section class="slds-accordion__section slds-is-open" data-id="sectionThree">
                    <div class="card-header" data-id="headingThree">
                        <h2 class="slds-accordion__summary-heading">
                            <button
                                type="button"
                                aria-controls="collapseThree"
                                aria-expanded="true"
                                class="slds-button slds-button_reset slds-accordion__summary-action"
                                data-parent="sectionThree"
                                onclick="{expandSection}"
                            >
                                <lightning-icon
                                    icon-name="utility:switch"
                                    alternative-text="button icon"
                                    size="x-small"
                                    class="slds-accordion__summary-action-icon slds-button__icon slds-button__icon_left"
                                ></lightning-icon>
                                <span
                                    style="background-color: var(--lwc-brandAccessible, rgb(0, 112, 210))"
                                    class="slds-badge slds-badge_inverse"
                                >
                                    2</span
                                ><span class="slds-accordion__summary-content"> ตรวจสอบขั้นตอนการประกอบ</span>
                            </button>
                            <div class="slds-col">
                                <div class="slds-checkbox obj-right">
                                    <input
                                        onchange="{disableSection}"
                                        type="checkbox"
                                        data-id="header-na-2"
                                        value="na"
                                        data-parent="sectionThree"
                                    />
                                    <label class="slds-checkbox__label" for="header-na-2">
                                        <span class="slds-checkbox_faux"></span>
                                        <span class="slds-form-element__label">input N/A</span>
                                    </label>
                                </div>
                            </div>
                        </h2>
                        <div class="slds-grid slds-gutters" style="display: none" data-id="2-remark">
                            <div class="slds-col">
                                <label class="slds-form-element__label" for="tank-no">Remark</label>
                                <div class="slds-form-element__control">
                                    <textarea data-id="2-input-remark" class="slds-textarea"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div data-id="collapseThree" class="slds-accordion__content">
                        <div
                            id="collapseThree"
                            class="collapse"
                            aria-labelledby="headingThree"
                            data-parent="#accordionExample"
                        >
                            <div class="card-body">
                                <div class="table-responsive" style="margin-bottom: 0rem">
                                    <table class="table">
                                        <thead>
                                            <td rowspan="2">
                                                <span class="slds-form-element__label">รายการที่ต้องการตรวจสอบ</span>
                                            </td>
                                            <td colspan="3" class="text-center">
                                                <span class="slds-form-element__label">ผลการตรวจสอบ</span>
                                            </td>
                                            <td rowspan="2" class="text-center pd-0-25">
                                                <span class="slds-form-element__label pd-right-0"
                                                    >วิธีการแก้ไขเมื่อไม่ผ่าน</span
                                                >
                                            </td>
                                            <td colspan="2" class="text-center">
                                                <span class="slds-form-element__label">ผลการแก้ไข</span>
                                            </td>
                                            <tr>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">ผ่าน</span>
                                                </td>
                                                <td class="text-center pd-0">
                                                    <span class="slds-form-element__label">ไม่ผ่าน</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">NA</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">ผ่าน</span>
                                                </td>
                                                <td class="text-center pd-0">
                                                    <span class="slds-form-element__label">ไม่ผ่าน</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label"
                                                        >2. ตรวจสอบขั้นตอนการประกอบ</span
                                                    >
                                                </td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >2.1 สวมโรเตอร์เข้าสเตเตอร์ ขดลวดต้องไม่เสียหาย ไม่มีการกระแทก
                                                        ไม่มีการเสียดสี</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-1-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-1-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-1-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="2-1-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-1-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-1-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10">
                                                        2.2 ยี่ห้อแบริ่งถูกต้องตรงตาม Sap, Name plate
                                                        และติดตั้งแบริ่งโดยแบริ่งต้องไม่เสียหาย</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-2-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-2-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-2-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="2-2-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-2-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-2-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >2.3 อัดจารบีที่แบริ่งจนเต็มช่องว่างทั้งหมด
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-3-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-3-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-3-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="2-3-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-3-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-3-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >2.4 เติมจารบีที่ฝาประกับนอกและใน 3/4 ของพื้นที่
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-4-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-4-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-4-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="2-4-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-4-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-4-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >2.5 ประกอบฝาครอบ DE &amp; NDE ตรงมาร์คที่ตอกไว้</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-5-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-5-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-5-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="2-5-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-5-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-5-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >2.6 ประกอบฝาประกับนอกและใน ให้ตรงมาร์คที่ตอกไว้</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-6-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-6-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-6-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="2-6-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-6-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-6-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >2.7 ประกอบซีลหรือโอริงถูกต้องตามตำแหน่งเดิม</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-7-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-7-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-7-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="2-7-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-7-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-7-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >2.8 ประกอบใบพัดและฝาครอบ ต้องไม่เสียดสี และถูกตำแหน่งเดิม</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-8-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-8-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-8-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="2-8-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-8-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-8-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10">
                                                        2.9 ทำการเก็บสีภายนอกที่ในมุมอับที่พ่นไม่ได้ ให้เรียบร้อย
                                                        ทั้งหมด</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-9-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-9-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-9-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="2-9-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-9-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-9-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10">
                                                        2.10 ระยะคัปปลิ้ง, พูลเลย์หรือเกียร์
                                                        ถูกต้องตามตำแหน่งเดิม(ตรงตามภาพถ่าย)</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-10-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-10-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-10-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="2-10-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-10-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="2-10-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </li>
            <li class="slds-accordion__list-item">
                <section class="slds-accordion__section slds-is-open" data-id="sectionFour">
                    <div class="card-header" data-id="headingFour">
                        <h2 class="slds-accordion__summary-heading">
                            <button
                                type="button"
                                aria-controls="collapseFour"
                                aria-expanded="true"
                                class="slds-button slds-button_reset slds-accordion__summary-action"
                                data-parent="sectionFour"
                                onclick="{expandSection}"
                            >
                                <lightning-icon
                                    icon-name="utility:switch"
                                    alternative-text="button icon"
                                    size="x-small"
                                    class="slds-accordion__summary-action-icon slds-button__icon slds-button__icon_left"
                                ></lightning-icon>
                                <span
                                    style="background-color: var(--lwc-brandAccessible, rgb(0, 112, 210))"
                                    class="slds-badge slds-badge_inverse"
                                >
                                    3</span
                                ><span class="slds-accordion__summary-content">
                                    ตรวจสอบขั้นตอนก่อนการ TEST ที่แท่นทดสอบ</span
                                >
                            </button>
                            <div class="slds-col">
                                <div class="slds-checkbox obj-right">
                                    <input
                                        onchange="{disableSection}"
                                        type="checkbox"
                                        data-id="header-na-3"
                                        value="na"
                                        data-parent="sectionFour"
                                    />
                                    <label class="slds-checkbox__label" for="header-na-3">
                                        <span class="slds-checkbox_faux"></span>
                                        <span class="slds-form-element__label">input N/A</span>
                                    </label>
                                </div>
                            </div>
                        </h2>
                        <div class="slds-grid slds-gutters" style="display: none" data-id="3-remark">
                            <div class="slds-col">
                                s
                                <label class="slds-form-element__label" for="tank-no">Remark</label>
                                <div class="slds-form-element__control">
                                    <textarea data-id="3-input-remark" class="slds-textarea"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div data-id="collapseFour" class="slds-accordion__content">
                        <div
                            id="collapseFour"
                            class="collapse"
                            aria-labelledby="headingFour"
                            data-parent="#accordionExample"
                        >
                            <div class="card-body">
                                <div class="table-responsive" style="margin-bottom: 0rem">
                                    <table class="table">
                                        <thead>
                                            <td rowspan="2">
                                                <span class="slds-form-element__label">รายการที่ต้องการตรวจสอบ</span>
                                            </td>
                                            <td colspan="3" class="text-center">
                                                <span class="slds-form-element__label">ผลการตรวจสอบ</span>
                                            </td>
                                            <td rowspan="2" class="text-center pd-0-25">
                                                <span class="slds-form-element__label pd-right-0"
                                                    >วิธีการแก้ไขเมื่อไม่ผ่าน</span
                                                >
                                            </td>
                                            <td colspan="2" class="text-center">
                                                <span class="slds-form-element__label">ผลการแก้ไข</span>
                                            </td>
                                            <tr>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">ผ่าน</span>
                                                </td>
                                                <td class="text-center pd-0">
                                                    <span class="slds-form-element__label">ไม่ผ่าน</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">NA</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">ผ่าน</span>
                                                </td>
                                                <td class="text-center pd-0">
                                                    <span class="slds-form-element__label">ไม่ผ่าน</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label"
                                                        >3. ตรวจสอบขั้นตอนก่อนการ TEST ที่แท่นทดสอบ</span
                                                    >
                                                </td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >3.1 สภาพเทอร์มินอลต้องสะอาด สีแห้งสนิท ไม่มีฝุ่น, คราบน้ำ,
                                                        คราบน้ำมัน</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-1-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-1-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-1-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="3-1-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-1-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-1-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10">
                                                        3.2 เทอร์มินอลต้องขันแน่นกับโครง และน็อตครบถ้วน</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-2-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-2-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-2-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="3-2-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-2-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-2-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >3.3 น็อตกราวน์ต้องสะอาดไม่มีสีเคลือบติด และต้องต่อกราวน์</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-3-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-3-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-3-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="3-3-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-3-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-3-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >3.4 เทอร์มินอลอุปกรณ์เสริมเช่นฮีตเตอร์, เทอร์โมสตัด,
                                                        เทอร์มิสเตอร์, RTD PT100 ใส่ครบถ้วน
                                                        และติดตั้งแน่นเรียบร้อย</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-4-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-4-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-4-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="3-4-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-4-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="3-4-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </li>
            <li class="slds-accordion__list-item">
                <section class="slds-accordion__section slds-is-open" data-id="sectionFive">
                    <div class="card-header" data-id="headingFive">
                        <h2 class="slds-accordion__summary-heading">
                            <button
                                type="button"
                                aria-controls="collapseFive"
                                aria-expanded="true"
                                class="slds-button slds-button_reset slds-accordion__summary-action"
                                data-parent="sectionFive"
                                onclick="{expandSection}"
                            >
                                <lightning-icon
                                    icon-name="utility:switch"
                                    alternative-text="button icon"
                                    size="x-small"
                                    class="slds-accordion__summary-action-icon slds-button__icon slds-button__icon_left"
                                ></lightning-icon>
                                <span
                                    style="background-color: var(--lwc-brandAccessible, rgb(0, 112, 210))"
                                    class="slds-badge slds-badge_inverse"
                                >
                                    4</span
                                ><span class="slds-accordion__summary-content">
                                    ตรวจสอบขั้นตอนการทดสอบที่แท่นทดสอบ NO-LOAD TEST</span
                                >
                            </button>
                            <div class="slds-col">
                                <div class="slds-checkbox obj-right">
                                    <input
                                        onchange="{disableSection}"
                                        type="checkbox"
                                        data-id="header-na-4"
                                        value="na"
                                        data-parent="sectionFive"
                                    />
                                    <label class="slds-checkbox__label" for="header-na-4">
                                        <span class="slds-checkbox_faux"></span>
                                        <span class="slds-form-element__label">input N/A</span>
                                    </label>
                                </div>
                            </div>
                        </h2>
                        <div class="slds-grid slds-gutters" style="display: none" data-id="4-remark">
                            <div class="slds-col">
                                s
                                <label class="slds-form-element__label" for="tank-no">Remark</label>
                                <div class="slds-form-element__control">
                                    <textarea data-id="4-input-remark" class="slds-textarea"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div data-id="collapseFive" class="slds-accordion__content">
                        <div
                            id="collapseFive"
                            class="collapse"
                            aria-labelledby="headingFive"
                            data-parent="#accordionExample"
                        >
                            <div class="card-body">
                                <div class="table-responsive" style="margin-bottom: 0rem">
                                    <table class="table">
                                        <thead>
                                            <td rowspan="2">
                                                <span class="slds-form-element__label">รายการที่ต้องการตรวจสอบ</span>
                                            </td>
                                            <td colspan="3" class="text-center">
                                                <span class="slds-form-element__label">ผลการตรวจสอบ</span>
                                            </td>
                                            <td rowspan="2" class="text-center pd-0-25">
                                                <span class="slds-form-element__label pd-right-0"
                                                    >วิธีการแก้ไขเมื่อไม่ผ่าน</span
                                                >
                                            </td>
                                            <td colspan="2" class="text-center">
                                                <span class="slds-form-element__label">ผลการแก้ไข</span>
                                            </td>
                                            <tr>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">ผ่าน</span>
                                                </td>
                                                <td class="text-center pd-0">
                                                    <span class="slds-form-element__label">ไม่ผ่าน</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">NA</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">ผ่าน</span>
                                                </td>
                                                <td class="text-center pd-0">
                                                    <span class="slds-form-element__label">ไม่ผ่าน</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label"
                                                        >4. ตรวจสอบขั้นตอนการทดสอบที่แท่นทดสอบ NO-LOAD TEST</span
                                                    >
                                                </td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >4.1 ทำการแก้ไข Soft foot ขณะทำการทดสอบแล้วค่าความสั่นปกติ
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-1-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-1-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-1-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="4-1-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-1-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-1-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10">
                                                        4.2 มอเตอร์ต้องไม่มีเสียงฮัมของสนามแม่เหล็ก
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-2-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-2-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-2-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="4-2-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-2-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-2-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >4.3 อุณหภูมิของแบริ่งปกติไม่เกิน 60°C และ
                                                        โครงมอเตอร์ปกติไม่เกิน 50°C</span
                                                    >
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-3-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-3-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-3-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="4-3-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-3-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="4-3-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </li>
            <li class="slds-accordion__list-item">
                <section class="slds-accordion__section slds-is-open" data-id="sectionSix">
                    <div class="card-header" data-id="headingSix">
                        <h2 class="slds-accordion__summary-heading">
                            <button
                                type="button"
                                aria-controls="collapseSix"
                                aria-expanded="true"
                                class="slds-button slds-button_reset slds-accordion__summary-action"
                                data-parent="sectionSix"
                                onclick="{expandSection}"
                            >
                                <lightning-icon
                                    icon-name="utility:switch"
                                    alternative-text="button icon"
                                    size="x-small"
                                    class="slds-accordion__summary-action-icon slds-button__icon slds-button__icon_left"
                                ></lightning-icon>
                                <span
                                    style="background-color: var(--lwc-brandAccessible, rgb(0, 112, 210))"
                                    class="slds-badge slds-badge_inverse"
                                >
                                    5</span
                                ><span class="slds-accordion__summary-content"> รายการที่ต้องตรวจสอบ</span>
                            </button>
                            <div class="slds-col">
                                <div class="slds-checkbox obj-right">
                                    <input
                                        onchange="{disableSection}"
                                        type="checkbox"
                                        data-id="header-na-5"
                                        value="na"
                                        data-parent="sectionSix"
                                    />
                                    <label class="slds-checkbox__label" for="header-na-5">
                                        <span class="slds-checkbox_faux"></span>
                                        <span class="slds-form-element__label">input N/A</span>
                                    </label>
                                </div>
                            </div>
                        </h2>
                        <div class="slds-grid slds-gutters" style="display: none" data-id="5-remark">
                            <div class="slds-col">
                                <label class="slds-form-element__label" for="tank-no">Remark</label>
                                <div class="slds-form-element__control">
                                    <textarea data-id="5-input-remark" class="slds-textarea"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div data-id="collapseSix" class="slds-accordion__content">
                        <div
                            id="collapseSix"
                            class="collapse"
                            aria-labelledby="headingSix"
                            data-parent="#accordionExample"
                        >
                            <div class="card-body">
                                <div class="table-responsive" style="margin-bottom: 0rem">
                                    <table class="table">
                                        <thead>
                                            <td rowspan="2">
                                                <span class="slds-form-element__label">รายการที่ต้องการตรวจสอบ</span>
                                            </td>
                                            <td colspan="3" class="text-center">
                                                <span class="slds-form-element__label">ผลการตรวจสอบ</span>
                                            </td>
                                            <td rowspan="2" class="text-center pd-0-25">
                                                <span class="slds-form-element__label pd-right-0"
                                                    >วิธีการแก้ไขเมื่อไม่ผ่าน</span
                                                >
                                            </td>
                                            <td colspan="2" class="text-center">
                                                <span class="slds-form-element__label">ผลการแก้ไข</span>
                                            </td>
                                            <tr>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">ผ่าน</span>
                                                </td>
                                                <td class="text-center pd-0">
                                                    <span class="slds-form-element__label">ไม่ผ่าน</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">NA</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">ผ่าน</span>
                                                </td>
                                                <td class="text-center pd-0">
                                                    <span class="slds-form-element__label">ไม่ผ่าน</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >5.1 Rotation ตรงกับการติดตั้งใช้งานจริง
                                                        <fieldset class="slds-form-element slds-form-element_compound">
                                                            <div class="slds-form-element__control">
                                                                <div class="slds-form-element__row">
                                                                    <div
                                                                        class="custom-control custom-radio"
                                                                        style="margin-top: 5px"
                                                                    >
                                                                        <input
                                                                            onchange="{onIEH}"
                                                                            type="radio"
                                                                            data-id="5-1-radio-1"
                                                                            class="custom-control-input"
                                                                            value="CW"
                                                                        />
                                                                        <label
                                                                            class="custom-control-label slds-form-element__label"
                                                                            for="5-1-radio-1"
                                                                            style="margin-top: 0px"
                                                                            >CW</label
                                                                        >
                                                                    </div>
                                                                    <div
                                                                        class="custom-control custom-radio"
                                                                        style="margin-top: 5px"
                                                                    >
                                                                        <input
                                                                            onchange="{onIEH}"
                                                                            type="radio"
                                                                            data-id="5-1-radio-2"
                                                                            class="custom-control-input"
                                                                            value="CWW"
                                                                        />
                                                                        <label
                                                                            class="custom-control-label slds-form-element__label"
                                                                            for="5-1-radio-2"
                                                                            >CWW</label
                                                                        >
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </fieldset> </span
                                                    ><br />
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >(ตาม Tag Motor Informatiom From ดูจากด้าน NDE Ref. WI.
                                                        ENEM-QWI-0008-MAIN)
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-1-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-1-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-1-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="5-1-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-1-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-1-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >5.2 Bearing ไม่มีเสียงดังผิดปกติ
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-2-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-2-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-2-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="5-2-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-2-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-2-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >5.3 วัดค่ากระแสของมอเตอร์</span
                                                    >
                                                    <div class="form-check form-check-inline pd-left-20">
                                                        <label class="slds-form-element__label" for="text-input-id-1"
                                                            >U :</label
                                                        >
                                                        <div class="slds-form-element__control w-40">
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="5-3-input-1"
                                                                class="slds-input"
                                                            />
                                                        </div>
                                                        <label
                                                            class="slds-form-element__label pd-l"
                                                            for="text-input-id-1"
                                                        >
                                                            A.</label
                                                        >
                                                    </div>
                                                    <div class="form-check form-check-inline pd-left-20">
                                                        <label class="slds-form-element__label" for="text-input-id-1"
                                                            >V :</label
                                                        >
                                                        <div class="slds-form-element__control w-40">
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="5-3-input-2"
                                                                class="slds-input"
                                                            />
                                                        </div>
                                                        <label
                                                            class="slds-form-element__label pd-l"
                                                            for="text-input-id-1"
                                                        >
                                                            A.</label
                                                        >
                                                    </div>
                                                    <div class="form-check form-check-inline pd-left-20">
                                                        <label class="slds-form-element__label" for="text-input-id-1"
                                                            >W :</label
                                                        >
                                                        <div class="slds-form-element__control w-40">
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="5-3-input-3"
                                                                class="slds-input"
                                                            />
                                                        </div>
                                                        <label
                                                            class="slds-form-element__label pd-l"
                                                            for="text-input-id-1"
                                                        >
                                                            A.</label
                                                        >
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-3-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-3-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-3-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="5-3-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-3-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-3-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >5.4 ค่า Vibration อยู่ในเกณฑ์ปกติ</span
                                                    ><br />
                                                    <span class="slds-form-element__label pd-left-20">- DE = </span
                                                    ><br />
                                                    <div class="form-check form-check-inline pd-left-20">
                                                        <label class="slds-form-element__label" for="text-input-id-1"
                                                            >V :</label
                                                        >
                                                        <div class="slds-form-element__control w-40">
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="5-4-input-1"
                                                                class="slds-input"
                                                            />
                                                        </div>
                                                        <label
                                                            class="slds-form-element__label pd-l"
                                                            for="text-input-id-1"
                                                        >
                                                            mm/sec,</label
                                                        >
                                                    </div>
                                                    <div class="form-check form-check-inline pd-left-20">
                                                        <label class="slds-form-element__label" for="text-input-id-1"
                                                            >H :</label
                                                        >
                                                        <div class="slds-form-element__control w-40">
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="5-4-input-2"
                                                                class="slds-input"
                                                            />
                                                        </div>
                                                        <label
                                                            class="slds-form-element__label pd-l"
                                                            for="text-input-id-1"
                                                        >
                                                            mm/sec,</label
                                                        >
                                                    </div>
                                                    <div class="form-check form-check-inline pd-left-20">
                                                        <label class="slds-form-element__label" for="text-input-id-1"
                                                            >A :</label
                                                        >
                                                        <div class="slds-form-element__control w-40">
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="5-4-input-3"
                                                                class="slds-input"
                                                            />
                                                        </div>
                                                        <label
                                                            class="slds-form-element__label pd-l"
                                                            for="text-input-id-1"
                                                        >
                                                            mm/sec</label
                                                        >
                                                    </div>
                                                    <span class="slds-form-element__label pd-left-20">- NDE = </span
                                                    ><br />
                                                    <div class="form-check form-check-inline pd-left-20">
                                                        <label class="slds-form-element__label" for="text-input-id-1"
                                                            >V :</label
                                                        >
                                                        <div class="slds-form-element__control w-40">
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="5-4-input-4"
                                                                class="slds-input"
                                                            />
                                                        </div>
                                                        <label
                                                            class="slds-form-element__label pd-l"
                                                            for="text-input-id-1"
                                                        >
                                                            mm/sec,</label
                                                        >
                                                    </div>
                                                    <div class="form-check form-check-inline pd-left-20">
                                                        <label class="slds-form-element__label" for="text-input-id-1"
                                                            >H :</label
                                                        >
                                                        <div class="slds-form-element__control w-40">
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="5-4-input-5"
                                                                class="slds-input"
                                                            />
                                                        </div>
                                                        <label
                                                            class="slds-form-element__label pd-l"
                                                            for="text-input-id-1"
                                                        >
                                                            mm/sec,</label
                                                        >
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-4-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-4-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-4-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="5-4-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-4-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-4-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10">5.5 IR</span
                                                    ><br />
                                                    <div class="form-check form-check-inline pd-left-20">
                                                        <label class="slds-form-element__label" for="text-input-id-1"
                                                            >Test 1 min = :</label
                                                        >
                                                        <div class="slds-form-element__control w-40">
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="5-5-input-1"
                                                                class="slds-input"
                                                            />
                                                        </div>
                                                    </div>
                                                    <div class="form-check form-check-inline pd-left-20">
                                                        <label class="slds-form-element__label" for="text-input-id-1"
                                                            >10 min =</label
                                                        >
                                                        <div class="slds-form-element__control w-40">
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="5-5-input-2"
                                                                class="slds-input"
                                                            />
                                                        </div>
                                                    </div>
                                                    <div class="form-check form-check-inline pd-left-20">
                                                        <label class="slds-form-element__label" for="text-input-id-1"
                                                            >PI =</label
                                                        >
                                                        <div class="slds-form-element__control w-40">
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="5-5-input-3"
                                                                class="slds-input"
                                                            />
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-5-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-5-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-5-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="5-5-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-5-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="5-5-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </li>
            <li class="slds-accordion__list-item">
                <section class="slds-accordion__section slds-is-open" data-id="sectionSeven">
                    <div class="card-header" data-id="headingSeven">
                        <h2 class="slds-accordion__summary-heading">
                            <button
                                type="button"
                                aria-controls="collapseSeven"
                                aria-expanded="true"
                                class="slds-button slds-button_reset slds-accordion__summary-action"
                                data-parent="sectionSeven"
                                onclick="{expandSection}"
                            >
                                <lightning-icon
                                    icon-name="utility:switch"
                                    alternative-text="button icon"
                                    size="x-small"
                                    class="slds-accordion__summary-action-icon slds-button__icon slds-button__icon_left"
                                ></lightning-icon>
                                <span
                                    style="background-color: var(--lwc-brandAccessible, rgb(0, 112, 210))"
                                    class="slds-badge slds-badge_inverse"
                                >
                                    6</span
                                ><span class="slds-accordion__summary-content"> Mechanical Inspection</span>
                            </button>
                            <div class="slds-col">
                                <div class="slds-checkbox obj-right">
                                    <input
                                        onchange="{disableSection}"
                                        type="checkbox"
                                        data-id="header-na-6"
                                        value="na"
                                        data-parent="sectionSeven"
                                    />
                                    <label class="slds-checkbox__label" for="header-na-6">
                                        <span class="slds-checkbox_faux"></span>
                                        <span class="slds-form-element__label">input N/A</span>
                                    </label>
                                </div>
                            </div>
                        </h2>
                        <div class="slds-grid slds-gutters" style="display: none" data-id="6-remark">
                            <div class="slds-col">
                                <label class="slds-form-element__label" for="tank-no">Remark</label>
                                <div class="slds-form-element__control">
                                    <textarea data-id="6-input-remark" class="slds-textarea"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div data-id="collapseSeven" class="slds-accordion__content">
                        <div
                            id="collapseSeven"
                            class="collapse"
                            aria-labelledby="headingSeven"
                            data-parent="#accordionExample"
                        >
                            <div class="card-body">
                                <div class="table-responsive" style="margin-bottom: 0rem">
                                    <table class="table">
                                        <thead>
                                            <td rowspan="2">
                                                <span class="slds-form-element__label">รายการที่ต้องการตรวจสอบ</span>
                                            </td>
                                            <td colspan="3" class="text-center">
                                                <span class="slds-form-element__label">ผลการตรวจสอบ</span>
                                            </td>
                                            <td rowspan="2" class="text-center pd-0-25">
                                                <span class="slds-form-element__label pd-right-0"
                                                    >วิธีการแก้ไขเมื่อไม่ผ่าน</span
                                                >
                                            </td>
                                            <td colspan="2" class="text-center">
                                                <span class="slds-form-element__label">ผลการแก้ไข</span>
                                            </td>
                                            <tr>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">ผ่าน</span>
                                                </td>
                                                <td class="text-center pd-0">
                                                    <span class="slds-form-element__label">ไม่ผ่าน</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">NA</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">ผ่าน</span>
                                                </td>
                                                <td class="text-center pd-0">
                                                    <span class="slds-form-element__label">ไม่ผ่าน</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label">6 Mechanical Inspection</span
                                                    ><br />
                                                    <img
                                                        src="https://thor--dev4--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0680p000000Smm2&operationContext=DELIVERY&contentId=05T0p000001qsV1&page=0&d=/a/0p0000008V7W/wUULfpRmbsFuWIO61Ml18mWLsNTPQwD5WDgelXnHPdw&oid=00D0p0000008gcw&dpt=null&viewId="
                                                        alt="Girl in a jacket"
                                                        width="200"
                                                        height="200"
                                                    />
                                                </td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                                <td class="text-center"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >Position 1 Shaft-todriver mating face perpendicularity and
                                                        surface flatness 0.025 mm.
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-1-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-1-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-1-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="6-1-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-1-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-1-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >Position 2 Shaft-todriver registered maximum run out 0.100 mm.
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-2-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-2-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-2-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="6-2-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-2-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-2-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >Position 3 Maximum shaft runout with rotor rotating freely
                                                        0.025 mm.
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-3-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-3-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-3-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="6-3-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-3-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-3-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >Position 4 Maximum axial float 0.125 mm.
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-4-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-4-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-4-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="6-4-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-4-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="6-4-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </li>
            <li class="slds-accordion__list-item">
                <section class="slds-accordion__section slds-is-open" data-id="sectionEight">
                    <div class="card-header" data-id="headingEight">
                        <h2 class="slds-accordion__summary-heading">
                            <button
                                type="button"
                                aria-controls="collapseEight"
                                aria-expanded="true"
                                class="slds-button slds-button_reset slds-accordion__summary-action"
                                data-parent="sectionEight"
                                onclick="{expandSection}"
                            >
                                <lightning-icon
                                    icon-name="utility:switch"
                                    alternative-text="button icon"
                                    size="x-small"
                                    class="slds-accordion__summary-action-icon slds-button__icon slds-button__icon_left"
                                ></lightning-icon>
                                <span
                                    style="background-color: var(--lwc-brandAccessible, rgb(0, 112, 210))"
                                    class="slds-badge slds-badge_inverse"
                                >
                                    7</span
                                ><span class="slds-accordion__summary-content"> Stator Rotor Inspection</span>
                            </button>
                            <div class="slds-col">
                                <div class="slds-checkbox obj-right">
                                    <input
                                        onchange="{disableSection}"
                                        type="checkbox"
                                        data-id="header-na-7"
                                        value="na"
                                        data-parent="sectionEight"
                                    />
                                    <label class="slds-checkbox__label" for="header-na-7">
                                        <span class="slds-checkbox_faux"></span>
                                        <span class="slds-form-element__label">input N/A</span>
                                    </label>
                                </div>
                            </div>
                        </h2>
                        <div class="slds-grid slds-gutters" style="display: none" data-id="7-remark">
                            <div class="slds-col">
                                <label class="slds-form-element__label" for="tank-no">Remark</label>
                                <div class="slds-form-element__control">
                                    <textarea data-id="7-input-remark" class="slds-textarea"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div data-id="collapseEight" class="slds-accordion__content">
                        <div
                            id="collapseEight"
                            class="collapse"
                            aria-labelledby="headingEight"
                            data-parent="#accordionExample"
                        >
                            <div class="card-body">
                                <div class="table-responsive" style="margin-bottom: 0rem">
                                    <table class="table">
                                        <thead>
                                            <td rowspan="2">
                                                <span class="slds-form-element__label">รายการที่ต้องการตรวจสอบ</span>
                                            </td>
                                            <td colspan="3" class="text-center">
                                                <span class="slds-form-element__label">ผลการตรวจสอบ</span>
                                            </td>
                                            <td rowspan="2" class="text-center pd-0-25">
                                                <span class="slds-form-element__label pd-right-0"
                                                    >วิธีการแก้ไขเมื่อไม่ผ่าน</span
                                                >
                                            </td>
                                            <td colspan="2" class="text-center">
                                                <span class="slds-form-element__label">ผลการแก้ไข</span>
                                            </td>
                                            <tr>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">ผ่าน</span>
                                                </td>
                                                <td class="text-center pd-0">
                                                    <span class="slds-form-element__label">ไม่ผ่าน</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">NA</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="slds-form-element__label">ผ่าน</span>
                                                </td>
                                                <td class="text-center pd-0">
                                                    <span class="slds-form-element__label">ไม่ผ่าน</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >7.1 สเตเตอร์ (Stator) The number of stator coils
                                                    </span>
                                                    <div class="slds-form-element w-80">
                                                        <div
                                                            class="slds-form-element__control slds-input-has-fixed-addon"
                                                        >
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="7-1-input"
                                                                class="slds-input"
                                                            />
                                                            <span
                                                                class="slds-form-element__addon slds-form-element__label"
                                                                >coils.</span
                                                            >
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-1-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-1-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-1-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="7-1-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-1-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-1-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >7.2 โรเตอร์ (Rotor) The number of rotor bars
                                                    </span>
                                                    <div class="slds-form-element w-80">
                                                        <div
                                                            class="slds-form-element__control slds-input-has-fixed-addon"
                                                        >
                                                            <input
                                                                onchange="{onIEH}"
                                                                type="number"
                                                                data-id="7-2-input"
                                                                class="slds-input"
                                                            />
                                                            <span
                                                                class="slds-form-element__addon slds-form-element__label"
                                                                >Bars.</span
                                                            >
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-2-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-2-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-2-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="7-2-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-2-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-2-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-40">
                                                    <span class="slds-form-element__label pd-left-10"
                                                        >7.3 Draft Report
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-3-pass"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-3-not-pass"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-3-na"
                                                            value="NA"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="slds-form-element__control">
                                                        <input
                                                            onchange="{onIEH}"
                                                            type="text"
                                                            data-id="7-3-howto"
                                                            class="slds-input"
                                                        />
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-3-pass-2"
                                                            value="Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <div class="form-check pd-left-radio">
                                                        <input
                                                            onchange="{onIEH}"
                                                            class="form-check-input"
                                                            type="radio"
                                                            data-id="7-3-not-pass-2"
                                                            value="Not Pass"
                                                        />
                                                        <span class="slds-form-element__label"> </span>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </li>
        </ul>
    </div>
    <section class="section slds-accordion__section">
        <div class="slds-button-group obj-right" role="group">
            <button data-id="saveEQCCStep" class="slds-button slds-button_brand mgr-5" onclick="{openSaveModal}">
                Save Draft
            </button>
            <button data-id="submitEQCCStep" class="slds-button slds-button_brand mgr-5" onclick="{openSubmitModal}">
                Submit
            </button>
            <button data-id="rejectEQCCStep" class="slds-button slds-button_brand">Reject</button>
        </div>
    </section>
</template>
