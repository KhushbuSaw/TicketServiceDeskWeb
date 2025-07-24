using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace TicketServiceDesk
{
    public partial class UserDashboard : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ServiceDeskConnectionString"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Email"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            if (!IsPostBack)
            {
                string email = Request.QueryString["email"];
                BindUserTicketsDetails(email);
            }
        }
        protected void BindUserTicketsDetails(string email)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                string userDetailsQuery = "SELECT UserID FROM Users WHERE Email = @Email";
                SqlCommand getUserCommand = new SqlCommand(userDetailsQuery, con);
                getUserCommand.Parameters.AddWithValue("@Email", email);

                object result = getUserCommand.ExecuteScalar();

                if (result == null)
                {
                    return;
                }

                int userId = Convert.ToInt32(result);

                string query = @"
                SELECT TicketID, RaisedByUserName, RaisedByUserEmail, TicketType, Status, CreatedDate, DeliveryDate, Description
                FROM Tickets
                WHERE AssignedToUserID = @AssignedToUserID";

                SqlCommand getTicketsCommand = new SqlCommand(query, con);
                getTicketsCommand.Parameters.AddWithValue("@AssignedToUserID", userId);

                SqlDataAdapter da = new SqlDataAdapter(getTicketsCommand);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTickets.DataSource = dt;
                gvTickets.DataBind();
            }
        }
        protected void gvUserTickets_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DateTime deliveryDate = Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "DeliveryDate"));
                Label lblDaysLeft = (Label)e.Row.FindControl("lblDaysLeft");

                int daysLeft = (deliveryDate - DateTime.Now.Date).Days;

                if (daysLeft < 0)
                {
                    lblDaysLeft.Text = "Overshoot by " + Math.Abs(daysLeft) + " day";
                    lblDaysLeft.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblDaysLeft.Text = daysLeft + " days left";
                    lblDaysLeft.ForeColor = System.Drawing.Color.Green;
                }
            }
        }
        protected void gvUserTickets_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditTicket")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                int ticketId = Convert.ToInt32(args[0]);
                string currentStatus = args[1];

                // Find the row and switch to edit mode
                GridViewRow row = ((Button)e.CommandSource).NamingContainer as GridViewRow;
                Label lblStatus = (Label)row.FindControl("lblStatus");
                DropDownList ddlStatus = (DropDownList)row.FindControl("ddlStatus");
                Button btnEdit = (Button)row.FindControl("btnEdit");
                Button btnSave = (Button)row.FindControl("btnSave");

                lblStatus.Visible = false;
                ddlStatus.Visible = true;
                btnEdit.Visible = false;
                btnSave.Visible = true;

                ddlStatus.SelectedValue = currentStatus;
            }
            else if (e.CommandName == "SaveTicket")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                int ticketId = Convert.ToInt32(args[0]);
                string email = args[1];

                GridViewRow row = ((Button)e.CommandSource).NamingContainer as GridViewRow;
                DropDownList ddlStatus = (DropDownList)row.FindControl("ddlStatus");

                string newStatus = ddlStatus.SelectedValue;

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string updateQuery = "UPDATE Tickets SET Status = @Status WHERE TicketID = @TicketID";
                    SqlCommand cmd = new SqlCommand(updateQuery, con);
                    cmd.Parameters.AddWithValue("@Status", newStatus);
                    cmd.Parameters.AddWithValue("@TicketID", ticketId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                BindUserTicketsDetails(email);
            }
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
        protected void btnStartConversation_Click(object sender, EventArgs e)
        {
            pnlConversation.Visible = true;
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
            }
        }
        protected void btnSendMessage_Click(object sender, EventArgs e)
        {
            string message = txtMessage.Text.Trim();
            string filePath = null;

            if (fileUpload.HasFile)
            {
                string folderPath = Server.MapPath("~/Uploads/");
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }
                string fileName = Path.GetFileName(fileUpload.FileName);
                filePath = "~/Uploads/" + fileName;
                fileUpload.SaveAs(folderPath + fileName);
            }

            int userId = Convert.ToInt32(Session["UserID"]);
            int ticketId = Convert.ToInt32(ViewState["CurrentTicketID"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string insert = "INSERT INTO TicketConversations (TicketID, UserID, MessageText, FilePath) VALUES (@TicketID, @UserID, @MessageText, @FilePath)";
                SqlCommand cmd = new SqlCommand(insert, con);
                cmd.Parameters.AddWithValue("@TicketID", ticketId);
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@MessageText", message);
                cmd.Parameters.AddWithValue("@FilePath", (object)filePath ?? DBNull.Value);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            txtMessage.Text = "";
            LoadConversation(ticketId);
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