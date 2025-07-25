<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TicketsByStatus.aspx.cs" Inherits="TicketServiceDesk.TicketsByStatus" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ticket Details</title>
</head>

<body>
    <form id="form1" runat="server">
         <div style="text-align: right;">
              <asp:Button ID="btnLogout" runat="server" Text="Logout" OnClick="btnLogout_Click" />
         </div>
        <div style="display: flex; float:left;">
        <div style="width: 65%; margin: 0 auto; padding: 20px; border: 1px solid #ccc;background-color:#e6f2ff; height: 388px;">
        <h2 style="text-align: center;"> <asp:Label ID="lblStatus" runat="server" /> Ticket Details</h2>

        <asp:GridView ID="gvTickets" runat="server" AutoGenerateColumns="False" OnRowCommand="gvTickets_RowCommand" OnRowDataBound="GridView1_RowDataBound" HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" RowStyle-HorizontalAlign="Center" OnSelectedIndexChanged="gvTickets_SelectedIndexChanged">
            <Columns>
                <asp:BoundField DataField="TicketID" HeaderText="Ticket Id" ReadOnly="true" />
                <asp:BoundField DataField="RaisedByUserName" HeaderText="Raised By" />
                <asp:BoundField DataField="RaisedByUserEmail" HeaderText="Raised By Email" />
                <asp:BoundField DataField="TicketType" HeaderText="Type" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
                <asp:BoundField DataField="CreatedDate" HeaderText="Raised on" />
                <asp:TemplateField HeaderText="Assignment Status">
                   <ItemTemplate>
                        <%# Convert.ToBoolean(Eval("Assigned")) ? "Assigned" : "Not Assigned" %>
                   </ItemTemplate>
                </asp:TemplateField>
               <asp:BoundField DataField="AssignedUserName" HeaderText="Currently Assigned To" />
               <asp:TemplateField>
                 <ItemTemplate>
                    <asp:Button ID="btnEdit" runat="server" CommandName="EditTicket"   CommandArgument='<%# Eval("TicketID") + "|" + Eval("Status") %>'  Text="Edit" />
                 </ItemTemplate>
             </asp:TemplateField>
              <asp:TemplateField>
                 <ItemTemplate>
                     <asp:Button ID="btnTicketConversation" runat="server" Text="Ticket's Conversation"
                         OnClick="btnTicketConversation_Click" CommandArgument='<%# Eval("TicketID") %>' />
                 </ItemTemplate>
             </asp:TemplateField>

            </Columns>
        </asp:GridView><br />
        </div>

        <div style="width:30%;padding-top:100px;padding-left:20px;">
               <div style="width:400px;height: 200px; overflow-y: auto;">
                <asp:Panel ID="pnlHeader" runat="server" Visible="false">
                    <h3>Past Conversation</h3>
                </asp:Panel>
                <asp:Panel ID="noConverartion" runat="server" Visible="false">
                    <h3>No Past Conversation</h3>
                </asp:Panel>
                <asp:Repeater ID="rptConversation" runat="server">
                   <ItemTemplate>
                    <div style="margin-bottom: 10px; border-bottom: 1px solid #ccc;">
                        <%# Eval("MessageText") %>

                        <asp:Button ID="btnDownload" runat="server"
                            Text="📎 Download Attachment"
                            CommandName="Download"
                            CommandArgument='<%# Eval("FilePath") %>'
                            Visible='<%# !string.IsNullOrEmpty(Eval("FilePath").ToString()) %>' 
                            OnCommand="btnDownload_Command" />
                    </div>
                  </ItemTemplate>
               </asp:Repeater>
              </div>
         </div>
        </div>
         
        <asp:Panel ID="pnlEditPopup" runat="server" CssClass="popup" Style="display:none;">
             <div style="width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ccc;background-color:steelblue; height: 222px;">
            <h3>Edit Ticket</h3>
            <asp:Label ID="lblTicketId" runat="server" Text="" Visible="false"></asp:Label>
            <asp:Label ID="tblTicketStatus" runat="server" Text="" Visible="false"></asp:Label>

            <label for="ddlUsers">Assign To:</label>
            <asp:DropDownList ID="ddlUsers" runat="server"></asp:DropDownList><br /><br />

            Select Delivery Date: 
            <input id="txtDate" type="date" runat="server" /><br /><br />
            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
            <asp:Button ID="btnSaveAndMail" runat="server" Text="Send Mail & Save" OnClick="btnSaveAndMail_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClientClick="hidePopup(); return false;" />
            </div>
        </asp:Panel>

         <script type="text/javascript">
             function showPopup() {
                 document.getElementById('<%= pnlEditPopup.ClientID %>').style.display = 'block';
}

            function hidePopup() {
                document.getElementById('<%= pnlEditPopup.ClientID %>').style.display = 'none';
                         }
         </script>
    </form>

    
</body>
</html>
