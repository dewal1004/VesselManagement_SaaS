codeunit 50004 "ItemJournalSubsriber"
{
    EventSubscriberInstance = StaticAutomatic;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Check Line", 'OnAfterGetItem', '', true, true)]
    // local procedure ItemJnlChkLineOn(var ItemJournalLine: Record "Item Journal Line")
    // var
    // begin
    //     NegCheck(ItemJournalLine);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Check Line", 'OnBeforeCheckBins', '', true, true)]
    // local procedure ItemJnlChkLineOnBeforeChkBins(var ItemJournalLine: Record "Item Journal Line")
    // var
    //     chki: Integer;
    //     Vend: Record 23;
    //     AllowedQty: Decimal;
    //     ChkArray: ARRAY[3, 3] OF Text[200];
    // begin

    // end;

    local procedure NegCheck(var ItemJnlLine: Record "Item Journal Line")
    var
        Item: Record Item;
    begin
        if (ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Sale) or
           (ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::"Negative Adjmt.") then begin
            Item.Get(ItemJnlLine."Item No.");
            If ItemJnlLine."Shortcut Dimension 2 Code" <> '' then
                Item.Setrange(Item."Global Dimension 2 Filter", ItemJnlLine."Shortcut Dimension 2 Code");
            Item.SetRange(Item."Location Filter", ItemJnlLine."Location Code");
            if ItemJnlLine."Variant Code" <> '' then
                Item.Setrange(Item."Variant Filter", ItemJnlLine."Variant Code");
            Item.CalcFields(Inventory);
            if Item.Inventory <= 0 then
                Error('Item No. %1, is not in Inventory at\' +
                      ' Location ' + '"%2."', Item."No.", ItemJnlLine."Location Code");
            if Item.Inventory < ItemJnlLine.Quantity then
                Error('Quantity is more than Inventory in Item No. %1.\' +
                       'at Location ' + '"%2."', Item."No.", ItemJnlLine."Location Code");
        end;

        if (ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::"Positive Adjmt.") then
            if (ItemJnlLine.Quantity < 0) then
                Error('Quantity Should not be Negative\' + 'in Line No. %1', ItemJnlLine."Line No.");
    end;
}
