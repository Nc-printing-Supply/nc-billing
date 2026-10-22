/** @type {import('next').NextConfig} */
const nextConfig = {
  serverExternalPackages: ["pg", "playwright-core", "bcryptjs"],
};

export default nextConfig;
