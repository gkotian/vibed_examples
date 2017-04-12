import vibe.vibe;

void main()
{
    auto router = new URLRouter;
    router.get("/", staticTemplate!"create.dt");
    router.get("/created", &createNote);
    router.post("/created", &createNote);

	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	listenHTTP(settings, router);

	logInfo("Please open http://127.0.0.1:8080/ in your browser.");
	runApplication();
}

void createNote(HTTPServerRequest req, HTTPServerResponse res)
{
    if (req.method != HTTPMethod.POST && req.method != HTTPMethod.GET)
        return;

    auto formdata = (req.method == HTTPMethod.POST) ? &req.form : &req.query;

    auto topic = formdata.get("form_topic");
    auto content = formdata.get("form_content");
    auto req_method_str = httpMethodString(req.method);

    render!("created.dt", topic, content, req_method_str)(res);
}
