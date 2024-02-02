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
        I := + +1;
        SetAppliedEntrytoAdjustFalse();
        TempMoveTransferredILE();
        IsHandled := True;
    end;

    local procedure SetAppliedEntrytoAdjustFalse()
    //To make transfer entry appeared as adjusted 
    var
        ItemLE: Record "Item Ledger Entry";
        TryItem: Label 'AG-001'; //DK-016, PK-0168
    begin
        ItemLE.SetCurrentKey("Item No.", "Entry Type", "Applied Entry to Adjust");
        ItemLE.SetRange("Item No.", TryItem);
        ItemLE.SetRange("Entry Type", ItemLE."Entry Type"::Transfer);
        ItemLE.SetRange("Applied Entry to Adjust", true);
        if ItemLE.FindSet() then begin
            ItemLE.SetCurrentKey("Entry No.");
            ItemLE.ModifyAll("Applied Entry to Adjust", false);
        end;
    end;

    local procedure TempMoveTransferredILE()
    var
        ILE: Record "Item Ledger Entry";
        ASLILE: Record "ASL Item Ledger Entry Buffer";
        payT: Record "Payment Method";
        ASLPayT: Record "Payment Terms" temporary;
    begin
        ILE.SetCurrentKey("Entry Type");
        if ILE.FindSet() then begin
            // Message('%1', ILE.Count);
            // ASLILE.Copy(ILE);
            // repeat begin
            // end until ILE.Next() = 0;
            // exit;
        end;

        ASLPayT.SetRange("Discount %");
        ASLPayT.TransferFields(payT);
        Message('%1', payT.Count);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Adjustment", OnBeforeMakeSingleLevelAdjmt, '', true, true)]
    local procedure InvtAdjmtOnBeforeMakeSingleLevelAdjmt()
    var
        I: Integer;
    begin
        I := + +1;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ASL Inventory Adjustment", OnMakeMultiLevelAdjmtOnAfterMakeAdjmt, '', true, true)]
    local procedure MyProcedure()
    var
        I: Integer;
    begin
        I := + +1;
    end;
}
