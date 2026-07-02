package uef.edu.vn.util;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

import uef.edu.vn.model.Movie;
import uef.edu.vn.model.Seat;
import uef.edu.vn.model.Showtime;
import uef.edu.vn.model.Ticket;

public final class TicketCheckPdfExporter {

    private static final SimpleDateFormat DATE_FMT = new SimpleDateFormat("dd/MM/yyyy");
    private static final SimpleDateFormat TIME_FMT = new SimpleDateFormat("HH:mm");
    private static final SimpleDateFormat DATETIME_FMT = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

    private TicketCheckPdfExporter() {
    }

    @SuppressWarnings("unchecked")
    public static byte[] export(Map<String, Object> exportData,
                                Integer ticketId,
                                Integer bookingId) throws DocumentException, IOException {
        List<Map<String, Object>> checkResults = exportData != null
                ? (List<Map<String, Object>>) exportData.get("checkResults") : null;
        Map<String, Object> invoiceInfo = exportData != null
                ? (Map<String, Object>) exportData.get("invoiceInfo") : null;

        Document document = new Document(PageSize.A4, 36, 36, 48, 36);
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        PdfWriter.getInstance(document, output);
        document.open();

        BaseFont baseFont = loadUnicodeBaseFont();
        Font titleFont = new Font(baseFont, 18, Font.BOLD, new Color(30, 30, 30));
        Font headerFont = new Font(baseFont, 12, Font.BOLD, new Color(50, 50, 50));
        Font normalFont = new Font(baseFont, 11, Font.NORMAL, new Color(60, 60, 60));
        Font boldFont = new Font(baseFont, 11, Font.BOLD, new Color(30, 30, 30));
        Font validFont = new Font(baseFont, 11, Font.BOLD, new Color(22, 163, 74));
        Font invalidFont = new Font(baseFont, 11, Font.BOLD, new Color(220, 38, 38));

        Paragraph title = new Paragraph("HÓA ĐƠN SOÁT VÉ", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(4f);
        document.add(title);

        Paragraph cinema = new Paragraph("STARLIGHT CINEMA", headerFont);
        cinema.setAlignment(Element.ALIGN_CENTER);
        cinema.setSpacingAfter(16f);
        document.add(cinema);

        document.add(new Paragraph("Thời gian xuất hóa đơn: " + DATETIME_FMT.format(new Date()), normalFont));

        if (ticketId != null && ticketId > 0) {
            document.add(new Paragraph("Loại soát: Theo mã vé #" + ticketId, normalFont));
        } else if (bookingId != null && bookingId > 0) {
            document.add(new Paragraph("Loại soát: Theo mã đơn đặt #" + bookingId, normalFont));
        }

        if (invoiceInfo != null && !invoiceInfo.isEmpty()) {
            document.add(new Paragraph(" ", normalFont));
            document.add(new Paragraph("THÔNG TIN HÓA ĐƠN", headerFont));
            addInvoiceLine(document, "Mã hóa đơn", "#" + invoiceInfo.get("bookingId"), normalFont, boldFont);
            addInvoiceLine(document, "Ngày đặt", formatTimestamp(invoiceInfo.get("bookingDate")), normalFont, boldFont);
            addInvoiceLine(document, "Khách hàng", safeValue(invoiceInfo.get("customerName")), normalFont, boldFont);
            addInvoiceLine(document, "Số điện thoại", safeValue(invoiceInfo.get("customerPhone")), normalFont, boldFont);
            addInvoiceLine(document, "Email", safeValue(invoiceInfo.get("customerEmail")), normalFont, boldFont);
            addInvoiceLine(document, "Phương thức thanh toán", safeValue(invoiceInfo.get("paymentMethod")), normalFont, boldFont);
            addInvoiceLine(document, "Trạng thái đơn", safeValue(invoiceInfo.get("bookingStatus")), normalFont, boldFont);
            if (invoiceInfo.get("totalAmount") instanceof Number) {
                addInvoiceLine(document, "Tổng thanh toán",
                        formatMoney(((Number) invoiceInfo.get("totalAmount")).doubleValue()), normalFont, boldFont);
            }
        }

        document.add(new Paragraph(" ", normalFont));
        document.add(new Paragraph("CHI TIẾT VÉ & KẾT QUẢ SOÁT", headerFont));
        document.add(new Paragraph(" ", normalFont));

        if (checkResults == null || checkResults.isEmpty()) {
            document.add(new Paragraph("Không có dữ liệu kết quả soát vé.", normalFont));
        } else {
            PdfPTable table = new PdfPTable(6);
            table.setWidthPercentage(100f);
            table.setWidths(new float[]{1.2f, 2.5f, 1f, 1.8f, 1.2f, 2.3f});
            addHeaderCell(table, "Mã vé", headerFont);
            addHeaderCell(table, "Phim", headerFont);
            addHeaderCell(table, "Ghế", headerFont);
            addHeaderCell(table, "Suất chiếu", headerFont);
            addHeaderCell(table, "Giá vé", headerFont);
            addHeaderCell(table, "Kết quả", headerFont);

            double ticketTotal = 0d;
            for (Map<String, Object> result : checkResults) {
                Ticket ticket = (Ticket) result.get("ticket");
                boolean valid = Boolean.TRUE.equals(result.get("valid"));
                String message = result.get("message") != null ? result.get("message").toString() : "";

                if (ticket == null) {
                    addBodyCell(table, "-", normalFont);
                    addBodyCell(table, "-", normalFont);
                    addBodyCell(table, "-", normalFont);
                    addBodyCell(table, "-", normalFont);
                    addBodyCell(table, "-", normalFont);
                    addBodyCell(table, message, invalidFont);
                    continue;
                }

                ticketTotal += ticket.getPrice();
                Showtime showtime = ticket.getShowtime();
                Movie movie = showtime != null ? showtime.getMovie() : null;
                Seat seat = ticket.getSeat();

                addBodyCell(table, "#" + ticket.getId_Ticket(), boldFont);
                addBodyCell(table, movie != null ? safe(movie.getTitle()) : "-", normalFont);
                addBodyCell(table, seat != null ? safe(seat.getSeatName()) : "-", normalFont);
                addBodyCell(table, formatShowtime(showtime), normalFont);
                addBodyCell(table, formatMoney(ticket.getPrice()), normalFont);
                addBodyCell(table, (valid ? "HỢP LỆ - " : "KHÔNG HỢP LỆ - ") + message,
                        valid ? validFont : invalidFont);
            }

            document.add(table);

            if (invoiceInfo == null || invoiceInfo.get("totalAmount") == null) {
                document.add(new Paragraph(" ", normalFont));
                Paragraph subtotal = new Paragraph("Tổng giá vé: " + formatMoney(ticketTotal), boldFont);
                subtotal.setAlignment(Element.ALIGN_RIGHT);
                document.add(subtotal);
            }
        }

        document.close();
        return output.toByteArray();
    }

    private static void addInvoiceLine(Document document, String label, String value,
                                       Font labelFont, Font valueFont) throws DocumentException {
        Paragraph line = new Paragraph();
        line.add(new Phrase(label + ": ", labelFont));
        line.add(new Phrase(value != null && !value.isBlank() ? value : "-", valueFont));
        line.setSpacingAfter(2f);
        document.add(line);
    }

    private static void addHeaderCell(PdfPTable table, String text, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setBackgroundColor(new Color(240, 240, 240));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setPadding(8f);
        table.addCell(cell);
    }

    private static void addBodyCell(PdfPTable table, String text, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setPadding(7f);
        table.addCell(cell);
    }

    private static String formatShowtime(Showtime showtime) {
        if (showtime == null) {
            return "-";
        }
        String datePart = showtime.getShowDate() != null ? DATE_FMT.format(showtime.getShowDate()) : "--/--/----";
        String timePart = formatTime(showtime.getStartTime());
        return datePart + " " + timePart;
    }

    private static String formatTime(Time time) {
        return time != null ? TIME_FMT.format(time) : "--:--";
    }

    private static String formatTimestamp(Object value) {
        if (value instanceof Timestamp) {
            return DATETIME_FMT.format((Timestamp) value);
        }
        if (value instanceof Date) {
            return DATETIME_FMT.format((Date) value);
        }
        return value != null ? value.toString() : "-";
    }

    private static String formatMoney(double amount) {
        return String.format("%,.0f đ", amount).replace(',', '.');
    }

    private static String safe(String value) {
        return value != null ? value : "-";
    }

    private static String safeValue(Object value) {
        return value != null ? value.toString() : "-";
    }

    private static BaseFont loadUnicodeBaseFont() throws DocumentException, IOException {
        try (InputStream is = TicketCheckPdfExporter.class.getResourceAsStream("/fonts/DejaVuSans.ttf")) {
            if (is != null) {
                byte[] fontBytes = is.readAllBytes();
                return BaseFont.createFont("DejaVuSans.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED, true, fontBytes, null);
            }
        }

        String[] candidates = {
                "C:\\Windows\\Fonts\\arial.ttf",
                "C:\\Windows\\Fonts\\segoeui.ttf",
                "C:\\Windows\\Fonts\\times.ttf",
                "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
                "/System/Library/Fonts/Supplemental/Arial Unicode.ttf"
        };
        for (String path : candidates) {
            if (new File(path).exists()) {
                return BaseFont.createFont(path, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            }
        }

        return BaseFont.createFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
    }
}
