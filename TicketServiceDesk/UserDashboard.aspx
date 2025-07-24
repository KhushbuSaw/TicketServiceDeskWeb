<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserDashboard.aspx.cs" Inherits="TicketServiceDesk.UserDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .grid {}
    </style>
</head>
<body>
    <form id="UserDashboardForm" runat="server">
          <div style="width: 100%; margin: 0 auto; padding: 20px; border: 1px solid #ccc;background-color:#e6f2ff; height: 300px;">
             <h2>My Assigned Tickets</h2>
        <asp:GridView ID="gvTickets" runat="server" AutoGenerateColumns="False" CssClass="grid" OnRowCommand="gvUserTickets_RowCommand" Height="161px" Width="1114px">
            <Columns>
                  <asp:BoundField DataField="TicketID" HeaderText="Ticket Id" ReadOnly="true" />
                  <asp:BoundField DataField="RaisedByUserName" HeaderText="Raised By" />
                  <asp:BoundField DataField="RaisedByUserEmail" HeaderText="Raised By Email" />
                  <asp:BoundField DataField="TicketType" HeaderText="Type" />
                  <asp:BoundField DataField="CreatedDate" HeaderText="Raised on" />
                  <asp:BoundField DataField="DeliveryDate" HeaderText="Delivery Date" />
                <asp:TemplateField HeaderText="Current Status">
                    <ItemTemplate>
                        <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>' />
                        <asp:DropDownList ID="ddlStatus" runat="server" Visible="false">
                            <asp:ListItem Text="Open" />
                            <asp:ListItem Text="Work-in-progress" />
                            <asp:ListItem Text="Resolved" />
                            <asp:ListItem Text="Closed" />
                        </asp:DropDownList>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                   <ItemTemplate>
                    <asp:Button ID="btnEdit" runat="server" CommandName="EditTicket" Text="Edit"
                        CommandArgument='<%# Eval("TicketID") + "|" + Eval("Status") + "|" + Request.QueryString["email"] %>' />
                    <asp:Button ID="btnSave" runat="server" CommandName="SaveTicket" Text="Save"
                        CommandArgument='<%# Eval("TicketID") + "|" + Request.QueryString["email"] %>' Visible="false" />
                   </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        </div>
    </form>
</body>
</html>
