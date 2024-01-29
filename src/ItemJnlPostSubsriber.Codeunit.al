codeunit 50010 "ItemJnlPostSubsriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", 'OnCodeOnAfterItemJnlPostBatchRun', '', true, true)]
    local procedure ItemJnlPostOnCodeOnAfterItemJnlPostBatchRun()
    begin
        PostAssociatedAsset();
    end;

    local procedure PostAssociatedAsset()
    var
        l_GenJournalLine: Record "Gen. Journal Line";
    begin
        l_GenJournalLine.Reset();
        l_GenJournalLine.SetRange("Ready to Post", true);
        if l_GenJournalLine.FindSet() then
            repeat
                CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", l_GenJournalLine);
            until l_GenJournalLine.Next() = 0;
    end;

    // Pending
    //   { PropertyModification;
    //     Target=Text001(Variable 1001);
    //     Property=TextConstString;
    //     OriginalValue=ENU=Do you want to post the journal lines?;
    //     ModifiedValue=ENU=Do you want to post Journals ?
    //   }
}
