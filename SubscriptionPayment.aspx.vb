Imports System.Web

Public Class SubscriptionPayment
    Inherits System.Web.UI.Page

    Private Sub RedirectToPayment(amount As Decimal, subscriptionType As String)
        ' الرابط الذي يعطيه البنك لاحقًا
        Dim bankPaymentUrl As String = "https://yourbankgateway.com/pay"
        bankPaymentUrl &= "?amount=" & amount.ToString("F2") & "&type=" & subscriptionType
        Response.Redirect(bankPaymentUrl)
    End Sub

    Protected Sub btnBasic_Click(sender As Object, e As EventArgs)
        RedirectToPayment(100, "Basic")
    End Sub

    Protected Sub btnVIP_Click(sender As Object, e As EventArgs)
        RedirectToPayment(130, "VIP")
    End Sub

    Protected Sub btnGold_Click(sender As Object, e As EventArgs)
        RedirectToPayment(160, "Gold")
    End Sub

    Protected Sub btnSilver_Click(sender As Object, e As EventArgs)
        RedirectToPayment(75, "Silver")
    End Sub

    Protected Sub btnPlatinum_Click(sender As Object, e As EventArgs)
        RedirectToPayment(100, "Platinum")
    End Sub

End Class
