// This script will open a new window focused on the current selection or its containing project.
'use strict';

function run() {
	let omnifocus = Application("OmniFocus");
	omnifocus.includeStandardAdditions = true;
	
	let perspectiveName = "Projects",
		perspectiveNames = omnifocus.perspectiveNames();
	if (perspectiveNames.includes("Focus")) {
		perspectiveName = "Focus";
	}
	
	let windows = omnifocus.windows();
	if (windows.length === 0) {
		return;
	}

	let frontmostWindow = windows[0],
		document = frontmostWindow.document(),
		documentWindows = document.documentWindows(),
		frontmostDocumentWindow = documentWindows[0],
		content = frontmostDocumentWindow.content(),
		selectedTrees = content.selectedTrees();
	if (selectedTrees.length === 0) {
		return;
	}

	let selectedItem = selectedTrees[0].value(),
    	containingProject = selectedItem.containingProject();
	if (!containingProject) {
		return;
	}

	var newDocumentWindow = omnifocus.DocumentWindow();
	document.documentWindows.push(newDocumentWindow);
	newDocumentWindow.focus = containingProject;
	newDocumentWindow.perspectiveName = "Focus";
}
