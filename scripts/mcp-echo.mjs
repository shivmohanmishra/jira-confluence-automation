import { McpServer } from "@modelcontextprotocol/server";
import { StdioServerTransport } from "@modelcontextprotocol/server/stdio";
import * as z from "zod/v4";

const server = new McpServer({ name: "echo-windows", version: "1.0.0" });

server.registerTool(
  "echo",
  {
    description: "Return the provided message unchanged.",
    inputSchema: z.object({ message: z.string() }),
  },
  async ({ message }) => ({
    content: [{ type: "text", text: message }],
  }),
);

await server.connect(new StdioServerTransport());