package com.bascode.util;

public final class HtmlUtil {
    private HtmlUtil() {}

    public static String escape(String s) {
        if (s == null) return "";
        // Minimal escaping for safe JSP scriptlet rendering.
        return s
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    public static String escapeWithBr(String s) {
        return escape(s).replace("\r\n", "\n").replace("\n", "<br/>");
    }

    public static String ellipsize(String s, int maxLen) {
        if (s == null) return "";
        if (maxLen <= 0) return "";
        if (s.length() <= maxLen) return s;
        if (maxLen <= 3) return s.substring(0, maxLen);
        return s.substring(0, Math.max(0, maxLen - 3)) + "...";
    }
}

