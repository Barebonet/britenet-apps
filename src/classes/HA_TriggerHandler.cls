/**
 * Created by bartosz.rozpara on 14.10.2022.
 */

public virtual class HA_TriggerHandler {

    @TestVisible
    private TriggerContext Context;

    @TestVisible
    private Boolean IsTriggerExecuting;

    public HA_TriggerHandler() {
        this.setTriggerContext();
    }

    public void run() {

        if (this.Context == TriggerContext.BEFORE_INSERT) {
            this.beforeInsert();
        } else if (this.Context == TriggerContext.BEFORE_UPDATE) {
            this.beforeUpdate();
        } else if (this.Context == TriggerContext.BEFORE_DELETE) {
            this.beforeDelete();
        } else if (this.Context == TriggerContext.AFTER_INSERT) {
            this.afterInsert();
        } else if (this.Context == TriggerContext.AFTER_UPDATE) {
            this.afterUpdate();
        } else if (this.Context == TriggerContext.AFTER_DELETE) {
            this.afterDelete();
        } else if (this.Context == TriggerContext.AFTER_UNDELETE) {
            this.afterUndelete();
        }
    }

    @TestVisible
    private void setTriggerContext() {
        this.setTriggerContext(null, false);
    }

    @TestVisible
    private void setTriggerContext(String ctx, Boolean test_mode) {
        if (!Trigger.isExecuting && !test_mode) {
            this.IsTriggerExecuting = false;
            return;
        } else {
            this.IsTriggerExecuting = true;
        }

        if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) || (ctx != null && ctx == 'before insert')) {
            this.Context = TriggerContext.BEFORE_INSERT;
        } else if (
                (Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) || (ctx != null && ctx == 'before update')
                ) {
            this.Context = TriggerContext.BEFORE_UPDATE;
        } else if (
                (Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) || (ctx != null && ctx == 'before delete')
                ) {
            this.Context = TriggerContext.BEFORE_DELETE;
        } else if (
                (Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) || (ctx != null && ctx == 'after insert')
                ) {
            this.Context = TriggerContext.AFTER_INSERT;
        } else if (
                (Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) || (ctx != null && ctx == 'after update')
                ) {
            this.Context = TriggerContext.AFTER_UPDATE;
        } else if (
                (Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) || (ctx != null && ctx == 'after delete')
                ) {
            this.Context = TriggerContext.AFTER_DELETE;
        } else if (
                (Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) || (ctx != null && ctx == 'after undelete')
                ) {
            this.Context = TriggerContext.AFTER_UNDELETE;
        }
    }

    @TestVisible
    protected virtual void beforeInsert() {
    }
    @TestVisible
    protected virtual void beforeUpdate() {
    }
    @TestVisible
    protected virtual void beforeDelete() {
    }
    @TestVisible
    protected virtual void afterInsert() {
    }
    @TestVisible
    protected virtual void afterUpdate() {
    }
    @TestVisible
    protected virtual void afterDelete() {
    }
    @TestVisible
    protected virtual void afterUndelete() {
    }

    @TestVisible
    private enum TriggerContext {
        BEFORE_INSERT,
        BEFORE_UPDATE,
        BEFORE_DELETE,
        AFTER_INSERT,
        AFTER_UPDATE,
        AFTER_DELETE,
        AFTER_UNDELETE
    }

    public class TriggerHandlerException extends Exception {
    }
}