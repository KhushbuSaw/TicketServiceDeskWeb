using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Mail;

namespace TicketServiceDesk
{
    public partial class TicketsByStatus : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ServiceDeskConnectionString"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string status = Request.QueryString["status"];
                lblStatus.Text = status;
                BindGrid(status);
            }

        }
        private void BindGrid(string status)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT TicketID,UserName,Email,TicketType,Status,CreatedDate,AssignedTo,DeliveryDate FROM Tickets WHERE Status=@Status", con);
                cmd.Parameters.AddWithValue("@Status", status);
                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);
                gvTickets.DataSource = dt;
                gvTickets.DataBind();
            }
        }

        protected void gvTickets_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdateTicket" || e.CommandName == "UpdateAndMailTicket")
            {
                int rowIndex = Convert.ToInt32(((GridViewRow)((Control)e.CommandSource).NamingContainer).RowIndex);
                GridViewRow row = gvTickets.Rows[rowIndex];

                int ticketId = Convert.ToInt32(e.CommandArgument);
                string assignedTo = ((TextBox)row.FindControl("txtAssignTo")).Text.Trim();
                string deliveryDateStr = ((TextBox)row.FindControl("txtDeliveryDate")).Text.Trim();

                DateTime? deliveryDate = null;
                if (DateTime.TryParse(deliveryDateStr, out DateTime parsedDate))
                {
                    deliveryDate = parsedDate;
                    //txtDeliveryDate.Text = deliveryDateStr;
                }
                UpdateTicket(ticketId, assignedTo, deliveryDate);
                if (e.CommandName == "UpdateAndMailTicket")
                {
                    SendMail(ticketId, assignedTo, deliveryDate);
                    lblMessage.Text = $"Mail sent to {assignedTo} and Ticket ID {ticketId} updated successfully!";
                }
                if (e.CommandName == "UpdateTicket")
                {
                    lblMessage.Text = $"Ticket ID {ticketId} updated successfully!";
                }
                BindGrid(lblStatus.Text);
            }
        }
        private void UpdateTicket(int ticketId, string assignedTo, DateTime? deliveryDate)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                int assigned = 1;
                string query = "UPDATE Tickets SET AssignedTo = @AssignedTo, DeliveryDate = @DeliveryDate,Assigned=@assigned WHERE TicketID = @TicketID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@AssignedTo", (object)assignedTo ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@DeliveryDate", (object)deliveryDate ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Assigned", assigned);
                cmd.Parameters.AddWithValue("@TicketID", ticketId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void SendMail(int ticketId, string assignedTo, DateTime? deliveryDate)
        {
            string subject = "Ticket Assigned to You";
            string body = $"Hello,<br/><br/>" +
                          $"A ticket has been assigned to you:<br/><br/>" +
                          $"<b>Ticket ID:</b> {ticketId}<br/>" +
                          $"<b>Delivery Date:</b> {(deliveryDate.HasValue ? deliveryDate.Value.ToString("yyyy-MM-dd") : "Not Set")}<br/><br/>" +
                          $"Please login to the system to review it.";

            MailMessage mail = new MailMessage();
            mail.To.Add(assignedTo);
            mail.Subject = subject;
            mail.Body = body;
            mail.IsBodyHtml = true;

            SmtpClient smtp = new SmtpClient();
            smtp.Send(mail);

        }

    }
}
