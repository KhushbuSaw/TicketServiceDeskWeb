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
          <div style="width: 100%; margin: 0 auto; padding: 20px; border: 1px solid #ccc;background-color:#e6f2ff; height: 222px;">
             <h2>My Assigned Tickets</h2>
        <asp:GridView ID="gvTickets" runat="server" AutoGenerateColumns="False" CssClass="grid" OnSelectedIndexChanged="gvTickets_SelectedIndexChanged" Height="161px" Width="1114px">
            <Columns>
                  <asp:BoundField DataField="TicketID" HeaderText="Ticket Id" ReadOnly="true" />
                  <asp:BoundField DataField="RaisedByUserName" HeaderText="Raised By" />
                  <asp:BoundField DataField="RaisedByUserEmail" HeaderText="Raised By Email" />
                  <asp:BoundField DataField="TicketType" HeaderText="Type" />
                  <asp:BoundField DataField="Status" HeaderText="Status" />
                  <asp:BoundField DataField="CreatedDate" HeaderText="Raised on" />
                  <asp:BoundField DataField="DeliveryDate" HeaderText="Delivery Date" />
            </Columns>
        </asp:GridView>
        </div>
    </form>
</body>
</html>
