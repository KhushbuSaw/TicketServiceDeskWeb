<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TicketsByStatus.aspx.cs" Inherits="TicketServiceDesk.TicketsByStatus" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ticket Details</title>
</head>

<body>
    <form id="form1" runat="server" style="background-color:#e6f2ff">
        <h2 style="text-align: center;"> <asp:Label ID="lblStatus" runat="server" /> Ticket Details</h2>

        <asp:GridView ID="gvTickets" runat="server" AutoGenerateColumns="False" OnRowCommand="gvTickets_RowCommand" Height="264px" Width="1205px" HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" RowStyle-HorizontalAlign="Center" OnSelectedIndexChanged="gvTickets_SelectedIndexChanged">
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
                    <asp:Button ID="btnEdit" runat="server" CommandName="EditTicket" CommandArgument='<%# Eval("TicketID") %>' Text="Edit" />
                 </ItemTemplate>
             </asp:TemplateField>

            </Columns>
        </asp:GridView><br />

         <!-- Popup Panel -->
         
        <asp:Panel ID="pnlEditPopup" runat="server" CssClass="popup" Style="display: none;">
             <div style="width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ccc;background-color:steelblue; height: 222px;">
            <h3>Edit Ticket</h3>
            <asp:Label ID="lblTicketId" runat="server" Text="" Visible="false"></asp:Label>

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
