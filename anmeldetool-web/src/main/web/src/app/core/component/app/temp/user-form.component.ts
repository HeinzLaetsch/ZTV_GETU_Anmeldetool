import { Component, computed, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
// Angular 22 Signal Forms Importe
import { form, FormField, required, validate } from '@angular/forms/signals';
// Angular Material v22 Importe für Autocomplete
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';

// Interface gemäss Vorgabe
export interface Person {
  id: string; // UID
  name: string;
  email: string;
}

@Component({
  selector: 'app-user-form',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    FormField, // Signal Form Directive
    MatFormFieldModule,
    MatInputModule,
    MatAutocompleteModule,
  ],
  templateUrl: './user-form.component.html',
  styleUrls: ['./user-form.component.css'],
})
export class UserFormComponent {
  // 1. Statische Liste von Personen als Mockdaten
  personenListe = signal<Person[]>([
    { id: 'u1', name: 'Max Mustermann', email: 'max@example.com' },
    { id: 'u2', name: 'Anna Schmidt', email: 'anna@example.com' },
    { id: 'u3', name: 'John Doe', email: 'john@example.com' },
  ]);

  // 2. Das Datenmodell des Formulars als Signal (Single Source of Truth)
  formModel = signal({
    password: '',
    selectedPersonText: '', // Freitext für das Autocomplete-Suchfeld
  });

  // 3. Signal Form Instanz mit Validierung definieren
  userForm = form(this.formModel, (schemaPath) => {
    required(schemaPath.password);
    required(schemaPath.selectedPersonText);

    validate(schemaPath.selectedPersonText, () => {
      const aktuellerText = this.formModel().selectedPersonText;
      const gewaehltePerson = this.chosenPerson();

      // Wenn keine Person gewählt wurde ODER der getippte Text nicht zum Objektnamen passt:
      if (!gewaehltePerson || gewaehltePerson.name !== aktuellerText) {
        return {
          kind: 'personNotSelected',
          message: 'Bitte wählen Sie eine gültige Person aus der Liste aus.',
        };
      }
      return null; // Alles valide!
    });
  });

  // 4. Gefilterte Liste berechnen (computed) basierend auf der Namenseingabe
  gefiltertePersonen = computed(() => {
    const suche = this.formModel().selectedPersonText.toLowerCase();
    return this.personenListe().filter((p) => p.name.toLowerCase().includes(suche));
  });

  // Hilfsvariable für die final ausgewählte Person
  chosenPerson = signal<Person | null>(null);

  // Event-Handler bei der Auswahl einer Person aus der Liste
  onPersonSelected(person: Person): void {
    this.chosenPerson.set(person);
    // Textfeld auf den gewählten Namen setzen
    this.formModel.update((current) => ({
      ...current,
      selectedPersonText: person.name,
    }));
  }

  onSubmit(): void {
    if (this.userForm().valid()) {
      console.log('Passwort:', this.formModel().password);
      console.log('Ausgewählte Person (Objekt):', this.chosenPerson());
    }
  }
}
