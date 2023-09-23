import "./styles.css";

export default function RootLayout({
	children,
}: {
	children: React.ReactNode;
}): JSX.Element {
	return (
		<html lang="en">
			<head>
				<link rel="shortcut icon" href="/favicon.ico" />
        <link rel="favicon" href="/favicon.ico" />
			</head>
			<body>{children}</body>
		</html>
	);
}
