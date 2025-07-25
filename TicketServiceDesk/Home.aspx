﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="TicketServiceDesk.Home" %>

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
         <div style="text-align: right;">
             <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" />
        </div>
        <div style="width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #ccc;background-color:#e6f2ff; height: 400px;">
            <h2>Raise a Ticket</h2>

            <asp:Label ID="lblUsername" runat="server" Text="Username: " />
            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" Width="181px" /><br /><br />

            <asp:Label ID="lblEmail" runat="server" Text="Email: " />
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" Width="212px" /><br /><br />

            <asp:Label ID="lblTicketType" runat="server" Text="Issue Type: " />
            <asp:DropDownList ID="ddlTicketType" runat="server" Width="184px">
                <asp:ListItem Text="Select Issue Type" Value="" />
                <asp:ListItem Text="Admin Issue" Value="Admin Issue" />
                <asp:ListItem Text="Billing Issue" Value="Billing Issue" />
                <asp:ListItem Text="Technical Issue" Value="Technical Issue" />
            </asp:DropDownList><br /><br />

            <asp:Label ID="lblDescription" runat="server" Text="Issue Description:"></asp:Label><br />
            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="50" Height="78px" Width="323px"></asp:TextBox><br /><br />


            <asp:Button ID="btnSubmit" runat="server" Text="Submit Ticket" OnClick="btnSubmit_Click" />
            <br /><br />
            <asp:Label ID="lblMessage" runat="server" ForeColor="Green" />
        </div>
    </form>
</body>
</html>
