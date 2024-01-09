codeunit 50035 "InventoryAdjustmentSubscriber"
{
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ASL Inventory Adjustment", 'OnBeforeCopyILEToILE', '', true, true)]
    local procedure InventoryAdjustmentOnBeforeCopyILEToILE(ItemLedgEntry: Record "Item Ledger Entry")
    var
        SkipItem: Label 'EG-0010';
    begin
        if ItemLedgEntry."Item No." = SkipItem then
            exit;
        ItemLedgEntry.SetFilter(ItemLedgEntry."Entry Type", '<>%1', ItemLedgEntry."Entry Type"::Transfer);  //Refactor (Place it outside this event)
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Adjustment", 'OnBeforeCopyILEToILE', '', true, true)]
    local procedure InventoryAdjustmentOnBeforeCopyILEToILE2(ItemLedgEntry: Record "Item Ledger Entry")
    var
        SkipItem: Label 'EG-0010';
    begin
        if ItemLedgEntry."Item No." = SkipItem then
            exit;
        ItemLedgEntry.SetFilter(ItemLedgEntry."Entry Type", '<>%1', ItemLedgEntry."Entry Type"::Transfer);  //Refactor (Place it outside this event)
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Adjustment", OnBeforeMakeMultiLevelAdjmt, '', true, true)]
    local procedure Adjustment(var IsHandled: Boolean)
    var
        ASLInventAdJCost: Codeunit "ASL Inventory Adjustment";
    begin
        ASLInventAdJCost.MakeMultiLevelAdjmt();

        IsHandled := True;

    end;
}