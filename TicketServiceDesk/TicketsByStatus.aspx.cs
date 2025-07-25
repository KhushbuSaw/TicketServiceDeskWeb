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
using System.Net;
using System.IO;

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
                BindTicketsDetails(status);
            }

        }
        private void BindTicketsDetails(string status)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                            SELECT 
                                t.TicketID,
                                t.RaisedByUserName,
                                t.RaisedByUserEmail,
                                t.TicketType,
                                t.Status,
                                t.CreatedDate,
                                t.Assigned,
                                t.AssignedToUserID,
                                u.UserName AS AssignedUserName
                            FROM Tickets t
                            LEFT JOIN Users u ON t.AssignedToUserID = u.UserID
                            WHERE t.Status=@Status";
                SqlCommand cmd = new SqlCommand(query, con);
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
            if (e.CommandName == "EditTicket")
            {
                pnlEditPopup.Visible = true;
                rptConversation.Visible = false;
                pnlHeader.Visible = false;
                noConverartion.Visible = false;
                int rowIndex = Convert.ToInt32(((GridViewRow)((Control)e.CommandSource).NamingContainer).RowIndex);
                GridViewRow row = gvTickets.Rows[rowIndex];

                string[] args = e.CommandArgument.ToString().Split('|');
                int ticketId = Convert.ToInt32(args[0]);
                lblTicketId.Text = ticketId.ToString();

                string status = args[1];
                tblTicketStatus.Text = status;
                BindUserDropdown();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "showPopup();", true);
            }
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            string ticketId = lblTicketId.Text;
            string assignedUserId = ddlUsers.SelectedValue;
            string selectedDeliveryDate = txtDate.Value;
            string status = tblTicketStatus.Text;
            DateTime? deliveryDate =null ;
            if (DateTime.TryParse(selectedDeliveryDate, out DateTime date))
            {
               deliveryDate = date;
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                int assigned = 1;
                if (status.Equals("Open"))
                    status = "Work-in-progress";
                SqlCommand cmd = new SqlCommand("UPDATE Tickets SET AssignedToUserID = @AssignedToUserID,Status = @Status,DeliveryDate=@DeliveryDate,Assigned=@Assigned WHERE TicketId = @TicketId", con);
                cmd.Parameters.AddWithValue("@AssignedToUserID", assignedUserId);
                cmd.Parameters.AddWithValue("@Status", status);
                cmd.Parameters.AddWithValue("@DeliveryDate", deliveryDate);
                cmd.Parameters.AddWithValue("@Assigned", assigned);
                cmd.Parameters.AddWithValue("@TicketId", ticketId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            BindTicketsDetails(lblStatus.Text);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HidePopup", "hidePopup();", true);
        }
        protected void btnSaveAndMail_Click(object sender, EventArgs e)
        { 
            string ticketId = lblTicketId.Text;
            string selectedDeliveryDate = txtDate.Value;
            string assignedUserId = ddlUsers.SelectedValue;
            string toEmail = null;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT Email FROM Users WHERE UserID = @UserID";
                SqlCommand command = new SqlCommand(query, con);
                command.Parameters.AddWithValue("@UserID", assignedUserId);
                con.Open();

                object result = command.ExecuteScalar();
                if (result != null)
                {
                    toEmail = result.ToString();
                }
            }

            DateTime? deliveryDate = null;
            if (DateTime.TryParse(selectedDeliveryDate, out DateTime date))
            {
                deliveryDate = date;
            }
            string fromMail = "service.desk6565@gmail.com";
            string fromPassword = "qohs nasx yqyz zdmh";
            string subject = "Ticket Assigned to You";
            string body = $"Hello,<br/><br/>" +
                          $"A ticket has been assigned to you:<br/><br/>" +
                          $"<b>Ticket ID:</b> {ticketId}<br/>" +
                          $"<b>Delivery Date:</b> {(deliveryDate.HasValue ? deliveryDate.Value.ToString("yyyy-MM-dd") : "Not Set")}<br/><br/>" +
                          $"Please login to the system to review it.";

            MailMessage mail = new MailMessage();
            mail.From = new MailAddress(fromMail);
            mail.To.Add(new MailAddress(toEmail));
            mail.Subject = subject;
            mail.Body = body;
            mail.IsBodyHtml = true;

            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.Credentials = new NetworkCredential(fromMail, fromPassword);
            smtp.EnableSsl = true;

            smtp.Send(mail);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('mail sent successfully');", true);
            btnSave_Click(sender, e);
        }

        private void BindUserDropdown()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string role = "user";
                SqlCommand cmd = new SqlCommand("SELECT UserId, UserName FROM [Users] where Role=@Role", con);
                cmd.Parameters.AddWithValue("@Role",role);
                con.Open();
                ddlUsers.DataSource = cmd.ExecuteReader();
                ddlUsers.DataTextField = "UserName";
                ddlUsers.DataValueField = "UserId";
                ddlUsers.DataBind();
                ddlUsers.Items.Insert(0, new ListItem("--Select User--", ""));
            }
        }
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string status = DataBinder.Eval(e.Row.DataItem, "Status").ToString();
                Button btnEdit = (Button)e.Row.FindControl("btnEdit");

                if (status.Equals("Closed", StringComparison.OrdinalIgnoreCase))
                {
                    btnEdit.Enabled = false;
                    btnEdit.CssClass = "disabled-button"; 
                }
            }
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
        protected void btnTicketConversation_Click(object sender, EventArgs e)
        {
            rptConversation.Visible = true;
            pnlHeader.Visible = true;
            pnlEditPopup.Visible = false;
            int ticketId = Convert.ToInt32(((Button)sender).CommandArgument);
            ViewState["CurrentTicketID"] = ticketId;
            LoadConversation(ticketId);
        }
        private void LoadConversation(int ticketId)
        {

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM TicketConversations WHERE TicketID = @TicketID ORDER BY CreatedAt ASC";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@TicketID", ticketId);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                rptConversation.DataSource = reader;
                rptConversation.DataBind();
                bool hasRow = reader.HasRows;
                pnlHeader.Visible = hasRow;
                noConverartion.Visible = !hasRow;
            }
        }
        protected void btnDownload_Command(object sender, CommandEventArgs e)
        {
            string relativePath = e.CommandArgument.ToString();
            string filePath = Server.MapPath(relativePath);

            if (File.Exists(filePath))
            {
                string fileName = Path.GetFileName(filePath);
                Response.Clear();
                Response.ContentType = "application/octet-stream";
                Response.AppendHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
                Response.TransmitFile(filePath);
                Response.End();
            }
            else
            {
                Response.Write("<script>alert('File not found.');</script>");
            }
        }
        protected void gvTickets_SelectedIndexChanged(object sender, EventArgs e)
        {
           
        }

    }
}
