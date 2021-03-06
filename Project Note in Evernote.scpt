JsOsaDAS1.001.00bplist00�Vscript_�(function() {

  let Evernote = new Application("Evernote");
  let OmniFocus = new Application("OmniFocus");
  OmniFocus.includeStandardAdditions = true;

  let document = OmniFocus.defaultDocument();
  let documentWindow = document.documentWindows()[0];
  let contentTree = documentWindow.content();

  function getSelectedTaskOrProject() {
    if (contentTree.selectedTrees.length != 1) {
      OmniFocus.displayDialog("No selection");
    }
    return contentTree.selectedTrees[0].value();
  }

  function pickNotebook() {
    let notebooks = Evernote.notebooks();
    let notebookNames = notebooks.map(function(notebook) { return notebook.name(); });
    let selections = OmniFocus.chooseFromList(notebookNames, {
      withTitle: "Notebook",
      withPrompt: "Choose a Notebook to create an empty note in.",
      multipleSelectionsAllowed: false,
      emptySelectionAllowed: false
    });
    let name = selections[0];
    let result = null;
    notebooks.forEach(notebook => {
      if (notebook.name() === name) {
        result = notebook;
      }
    });
    return result;
  }

  /**
   * Finds an existing note or creates a new note with the given name in a specific
   * Evernote notebook.
   *
   * @param notebook Reference to a {@code Notebook}.
   * @param title Title of the note to find or create.
   * @param text Text to put in the note if a new note was created.
   */
  function getOrCreateNote(notebook, title, text = "") {
    if (!notebook) {
      return;
    }
    let note = null;
    notebook.notes().forEach(n => {
      if (n.title() == title) {
        note = n;
      }
    });
    if (note) {
      return note;
    } else {
      note = Evernote.createNote({
        title: title,
        notebook: notebook,
        withText: text
      });
      Evernote.synchronize();
      return note;
    }
  }

  let selectedItem = getSelectedTaskOrProject();
  let name = selectedItem.name();
  if (!name) {
    OmniFocus.displayDialog("Selected task does not have a name.");
    return;
  }

  let text = (selectedItem && selectedItem.note()) || "";

  let notebook = pickNotebook();
  if (!notebook) {
    return;
  }

  let note = getOrCreateNote(notebook, name, text);
  let link = note.noteLink();

  selectedItem.note = link;
})();
                              �jscr  ��ޭ