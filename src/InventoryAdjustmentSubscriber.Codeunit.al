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
        ItemLedgEntry.SetFilter(ItemLedgEntry."Entry Type", '<>%1', ItemLedgEntry."Entry Type"::Transfer);
    end;       
    
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Adjustment", OnBeforeMakeMultiLevelAdjmt, '', true, true)]
    local procedure Adjustment(var IsHandled: Boolean)
    var
        
        I: Integer;
        Adj: Codeunit "Inventory Adjustment Handler";
    begin
        // ASLInventAdJCost.MakeMultiLevelAdjmt();
        // IsHandled := True;
        I := ++1;        
    end;

    local procedure ASLInvtAdjstCost()
    var
        ASLInventAdJCost: Codeunit "ASL Inventory Adjustment";
    begin
        
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Adjustment", OnBeforeMakeSingleLevelAdjmt, '', true, true)]
    local procedure InvtAdjmtOnBeforeMakeSingleLevelAdjmt()
    var
      I: Integer;
    begin
        I := ++1;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ASL Inventory Adjustment", OnMakeMultiLevelAdjmtOnAfterMakeAdjmt, '', true, true)]
    local procedure MyProcedure()
    var
      I: Integer;
    begin
        I := ++1;
    end;
}