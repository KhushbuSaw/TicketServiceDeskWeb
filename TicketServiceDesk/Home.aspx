<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="TicketServiceDesk.Home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
      <title>Raise a Ticket</title>
      <style type="text/css">
          .form-control {
              margin-left: 6px;
          }
      </style>
</head>
<body>
    <form id="TicketForm" runat="server">
        <div style="width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ccc;background-color:#e6f2ff; height: 322px;">
            <h2>Raise a Ticket</h2>

            <asp:Label ID="lblUsername" runat="server" Text="Username: " />
            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" Width="181px" /><br /><br />

            <asp:Label ID="lblPassword" runat="server" Text="Password: " />
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Placeholder="Password" Width="187px" /><br /><br />

            <asp:Label ID="lblEmail" runat="server" Text="Email: " />
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" Width="212px" /><br /><br />

            <asp:Label ID="lblTicketType" runat="server" Text="Issue Type: " />
            <asp:DropDownList ID="ddlTicketType" runat="server" Width="184px">
                <asp:ListItem Text="Select Issue Type" Value="" />
                <asp:ListItem Text="Admin Issue" Value="Admin Issue" />
                <asp:ListItem Text="Billing Issue" Value="Billing Issue" />
                <asp:ListItem Text="Technical Issue" Value="Technical Issue" />
            </asp:DropDownList><br />

            <br />

            <asp:Button ID="btnSubmit" runat="server" Text="Submit Ticket" OnClick="btnSubmit_Click" />
            <br />
            <asp:Label ID="lblMessage" runat="server" ForeColor="Green" />
        </div>
    </form>
</body>
</html>
