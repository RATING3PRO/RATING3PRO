export default {
  async fetch(req) {
    const url = new URL(req.url)
    const filename = url.pathname.split("/").pop()

    const upstream = await fetch(
      "https://raw.githubusercontent.com/RATING3PRO/RATING3PRO/main/" + filename
    )

    return new Response(upstream.body, {
      headers: {
        "Content-Type": "application/octet-stream",
        "Content-Disposition": `attachment; filename="${filename}"`,
        "Cache-Control": "public, max-age=86400"
      }
    })
  }
}
