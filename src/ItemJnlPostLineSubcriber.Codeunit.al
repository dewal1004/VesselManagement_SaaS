codeunit 50028 "ItemJnlPostLineSubcriber"
{
    EventSubscriberInstance = StaticAutomatic;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforePostItem', '', true, true)]
    // local procedure ItemJnlPostLineOnBeforePostItem(var ItemJournalLine: Record "Item Journal Line")
    // var
    //     ItemAvailability: Codeunit "Item-Check Avail.";
    //     text001: Label 'ENU="%1 is Insurficient in Line %2   "';
    // begin
    //     IF ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Transfer THEN
    //         IF ItemAvailability.ItemJnlCheckLine(ItemJournalLine) THEN //IF ItemAvailability.ItemJnlCheckLinePost(ItemJnlLine) THEN
    //             ERROR(text001, ItemJournalLine."Item No.", ItemJournalLine."Line No.");
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterUpdateUnitCost', '', true, true)]
    // local procedure ItemJnlPostLineOnAfterUpdateUnitCost(ItemJournalLine: Record "Item Journal Line"; ValueEntry: Record "Value Entry"; LastDirectCost: Decimal)
    // var
    //     Item: Record Item;
    //     CompanyInfo: Record "Company Information";
    // begin
    //     if (ValueEntry."Valued Quantity" > 0) and
    //       (ItemJournalLine.Amount + ItemJournalLine."Discount Amount" > 0) and
    //       not (ValueEntry."Expected Cost" or ItemJournalLine.Adjustment) then begin
    //         item.Get(ItemJournalLine."No.");
    //         if (ItemJournalLine."Indirect Cost %" >= CompanyInfo."Min Foreign Indirect Cost %") then
    //             Item."Last Imported Cost" := LastDirectCost
    //         else
    //             Item."Last Local Cost" := LastDirectCost;
    //         Item.Modify;
    //     end
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', true, true)]
    local procedure ItemJnlPostLineOnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line")
    begin
        NewItemLedgEntry."Source Code" := ItemJournalLine."Source Code";
        NewItemLedgEntry."Scrap Quantity" := ItemJournalLine."Scrap Quantity";
        NewItemLedgEntry."Consumed Quantity" := ItemJournalLine."Consumed Quantity";
        NewItemLedgEntry."Vessel Type" := ItemJournalLine."Vessel Type";
        if ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Consumption then begin
            NewItemLedgEntry.Quantity := -ItemJournalLine."Consumed Quantity";
            NewItemLedgEntry."Invoiced Quantity" := -ItemJournalLine."Consumed Quantity";
        end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforePostInventoryToGL', '', true, true)]
    // local procedure ItemJnlPostLineOnBeforePostInventoryToGL(var ValueEntry: Record "Value Entry"; var IsHandled: Boolean)
    // begin
    //     if ValueEntry."Item Ledger Entry Type" = ValueEntry."Item Ledger Entry Type"::Transfer then
    //         IsHandled := true;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitValueEntry', '', true, true)]
    // local procedure ItemJnlPostLineOnAfterInitValueEntry(var ValueEntry: Record "Value Entry"; ItemJournalLine: Record "Item Journal Line")
    // begin
    // end;

    //>>>>>>>>>>>>>>>> Stop

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforePostInventoryToGL', '', true, true)]
    // local procedure ItemJnlPostLine()
    // begin
    // end;
}

//   CHANGES
//   {}
//     { CodeModification  ;OriginalCode=BEGIN
//                                         with ItemJnlLine do begin
//                                           if IsWarehouseReclassification(ItemJnlLine) then begin
//                                             ValueEntry."Dimension Set ID" := OldItemLedgEntry."Dimension Set ID";
//                                         #4..22
//                                               end;
//                                           RoundAmtValueEntry(ValueEntry);

//                                           if ValueEntry."Entry Type" = ValueEntry."Entry Type"::Rounding then begin
//                                             ValueEntry."Valued Quantity" := ItemLedgEntry.Quantity;
//                                             ValueEntry."Invoiced Quantity" := 0;
//                                             ValueEntry."Cost per Unit" := 0;
//                                             ValueEntry."Sales Amount (Actual)" := 0;
//                                             ValueEntry."Purchase Amount (Actual)" := 0;
//                                             ValueEntry."Cost per Unit (ACY)" := 0;
//                                             ValueEntry."Item Ledger Entry Quantity" := 0;
//                                           end else begin
//                                             if IsFirstValueEntry(ValueEntry."Item Ledger Entry No.") then
//                                               ValueEntry."Item Ledger Entry Quantity" := ValueEntry."Valued Quantity"
//                                             else
//                                               ValueEntry."Item Ledger Entry Quantity" := 0;
//                                             if ValueEntry."Cost per Unit" = 0 then begin
//                                               ValueEntry."Cost per Unit" :=
//                                                 CalcCostPerUnit(ValueEntry."Cost Amount (Actual)",ValueEntry."Valued Quantity",false);
//                                               ValueEntry."Cost per Unit (ACY)" :=
//                                                 CalcCostPerUnit(ValueEntry."Cost Amount (Actual) (ACY)",ValueEntry."Valued Quantity",true);
//                                             end else begin
//                                               ValueEntry."Cost per Unit" := Round(
//                                                   ValueEntry."Cost per Unit",GLSetup."Unit-Amount Rounding Precision");
//                                               ValueEntry."Cost per Unit (ACY)" := Round(
//                                         #48..57
//                                                   else
//                                                     ValueEntry."Cost per Unit" :=
//                                                       CalcCostPerUnit(ValueEntry."Cost Amount (Actual)",ValueEntry."Valued Quantity",false);
//                                             end;
//                                             if UpdateItemLedgEntry(ValueEntry,ItemLedgEntry) then
//                                               ItemLedgEntry.Modify;
//                                           end;

//                                           if ((ValueEntry."Entry Type" = ValueEntry."Entry Type"::"Direct Cost") and
//                                               (ValueEntry."Item Charge No." = '')) and
//                                         #68..73
//                                                 InvoicedQty := InvdValueEntry."Invoiced Quantity"
//                                               else
//                                                 InvoicedQty := ValueEntry."Valued Quantity";
//                                             end else
//                                               InvoicedQty := ValueEntry."Invoiced Quantity";
//                                             CalcExpectedCost(
//                                               ValueEntry,
//                                         #81..85
//                                               ValueEntry."Sales Amount (Expected)",
//                                               ValueEntry."Purchase Amount (Expected)",
//                                               ItemLedgEntry.Quantity = ItemLedgEntry."Invoiced Quantity");
//                                           end;

//                                           OnBeforeInsertValueEntry(ValueEntry,ItemJnlLine,ItemLedgEntry,ValueEntryNo,InventoryPostingToGL,CalledFromAdjustment);

//                                           if ValueEntry.Inventoriable and not Item."Inventory Value Zero" then
//                                             PostInventoryToGL(ValueEntry);

//                                           ValueEntry.Insert;

//                                           OnAfterInsertValueEntry(ValueEntry,ItemJnlLine,ItemLedgEntry,ValueEntryNo);
//                                         #99..108
//                                             TempValueEntryRelation.Insert;
//                                           end;
//                                         end;
//                                       END;

//                          ModifiedCode=BEGIN

//                                         //IF CONFIRM('Insert Value %1  of %2',FALSE, ValueEntry."Item Ledger Entry Type",ValueEntry."Source Code") THEN
//                                         if (ValueEntry."Item Ledger Entry Type" = ValueEntry."Item Ledger Entry Type"::Transfer) and (ValueEntry."Source Code" = 'INVTADJMT') then exit;//inserted by SHOD 01/08/18
//                                         #96..111
//                                       END;

//                          Target=InsertValueEntry(PROCEDURE 5801) }

//   CODE
//   {
//     BEGIN
//     END.
//   }
// }

// //********************
// // OBJECT Modification "Item Jnl.-Post Line"(Codeunit 22)
// // {
// //   OBJECT-PROPERTIES
// //   {
// //     Date=20210923D;
// //     Time=184832.553T;
// //     Modified=true;
// //     Version List=NAVW114.26;
// //   }
// //   PROPERTIES
// //   {
// //     Target="Item Jnl.-Post Line"(Codeunit 22);
// //   }

// { Skip(Redundant):CodeModification  ;OriginalCode=BEGIN
//                                         OnBeforePostItemJnlLine(ItemJnlLine,CalledFromAdjustment,CalledFromInvtPutawayPick);

//                                         with ItemJnlLine do begin
//                                         #4..57
//                                           then
//                                             GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group");

//                                           if "Qty. per Unit of Measure" = 0 then
//                                             "Qty. per Unit of Measure" := 1;
//                                           if "Qty. per Cap. Unit of Measure" = 0 then
//                                         #64..132
//                                         end;

//                                         OnAfterPostItemJnlLine(ItemJnlLine,GlobalItemLedgEntry,ValueEntryNo,InventoryPostingToGL);
//                                       END;

//                          ModifiedCode=BEGIN
//                                         #1..60
//                                           GetGLSetup;
//                                         #61..135
//                                       END;

//                          Target=Code(PROCEDURE 3) }
//     { Dropped: CodeModification  ;OriginalCode=BEGIN
//                                         if not InventoryPeriod.IsValidDate(ItemApplnEntry."Posting Date") then
//                                           InventoryPeriod.ShowError(ItemApplnEntry."Posting Date");

//                                         #4..52
//                                                 0,0,ItemApplnEntry."Posting Date",ItemApplnEntry.Quantity,true);
//                                         end;

//                                         if Item."Costing Method" = Item."Costing Method"::Average then
//                                           if ItemApplnEntry.Fixed then
//                                             UpdateValuedByAverageCost(CostItemLedgEntry."Entry No.",true);
//                                         #59..76
//                                         SetValuationDateAllValueEntrie(CostItemLedgEntry."Entry No.",Valuationdate,false);

//                                         UpdateLinkedValuationUnapply(Valuationdate,CostItemLedgEntry."Entry No.",CostItemLedgEntry.Positive);
//                                       END;

//                          ModifiedCode=BEGIN
//                                         #1..55
//                                         {IF ItemJnlLine."Item Tracking No." = 0 THEN
//                                                       UpdateRelatedItemTracking(OldItemLedgEntry."Entry No.",-AppliedQty);} // blocked by santus 20-10-05

//                                         #56..79
//                                       END;

//                          Target=UnApply(PROCEDURE 73) }

// { Skip(Refactor:Shod):CodeModification  ;OriginalCode=BEGIN
//                                         if ItemLedgEntryType = ValueEntry."Item Ledger Entry Type"::" " then
//                                           exit;
//                                         if Adjustment then
//                                           if not (ItemLedgEntryType in [ValueEntry."Item Ledger Entry Type"::Output,
//                                                                         ValueEntry."Item Ledger Entry Type"::"Assembly Output"])
//                                           then
//                                             exit;

//                                         #9..22
//                                             if ModifyItem then
//                                               Modify;
//                                           end;
//                                       END;

//                          ModifiedCode=BEGIN
//                                         #1..4
//                                                                         ValueEntry."Item Ledger Entry Type"::"Assembly Output",
//                                                                         ValueEntry."Item Ledger Entry Type"::Transfer]) // Inserted by Shod 01/08/18
//                                         #6..25
//                                       END;

// { Skip(Not required): CodeModification  ;OriginalCode=BEGIN
//                                         with TempSplitItemJnlLine do begin
//                                           "Quantity (Base)" := SignFactor * TempTrackingSpecification."Qty. to Handle (Base)";
//                                           Quantity := SignFactor * TempTrackingSpecification."Qty. to Handle";
//                                         #4..42
//                                           end;

//                                           if Round("Unit Amount" * Quantity,GLSetup."Amount Rounding Precision") <> Amount then
//                                             if ("Unit Amount" = "Unit Cost") and ("Unit Cost" <> 0) then begin
//                                               "Unit Amount" := Round(Amount / Quantity,0.00001);
//                                               "Unit Cost" := Round(Amount / Quantity,0.00001);
//                                               "Unit Cost (ACY)" := Round("Amount (ACY)" / Quantity,0.00001);
//                                         #50..77
//                                         end;

//                                         exit(PostItemJnlLine);
//                                       END;

//                          ModifiedCode=BEGIN
//                                         #1..45
//                                             if "Unit Amount" = "Unit Cost" then begin
//                                         #47..80
//                                       END;

//                          Target=SetupTempSplitItemJnlLine(PROCEDURE 101) }

//     { PropertyModification;
//                          Target=LineNoTxt(Variable 1090);
//                          Property=Id;
//                          OriginalValue=1090;
//                          ModifiedValue=1190 }
//     { PropertyModification;
//                          Target=TempItemApplnEntryHistory(Variable 1095);
//                          Property=Id;
//                          OriginalValue=1095;
//                          ModifiedValue=1101 }
//     { PropertyModification;
//                          Target=RoundingResidualAmount(Variable 1096);
//                          Property=Id;
//                          OriginalValue=1096;
//                          ModifiedValue=1196 }
//     { PropertyModification;
//                          Target=RoundingResidualAmountACY(Variable 1097);
//                          Property=Id;
//                          OriginalValue=1097;
//                          ModifiedValue=1197 }
//     { PropertyModification;
//                          Target=SkipApplicationCheck(Variable 1089);
//                          Property=Id;
//                          OriginalValue=1089;
//                          ModifiedValue=1099 }

//     { Insertion         ;InsertAfter=SkipApplicationCheck(Variable 1089);
//                          ChangedElements=VariableCollection
//                          {
//                            "-------------"@1090 : Text[30];
//                            Text005@1095 : TextConst 'ENU=Item %1 is not on inventory at Location %2.';
//                            TransferQtyItetmTracking@1096 : Decimal;

//                          }
//                           }
//   }