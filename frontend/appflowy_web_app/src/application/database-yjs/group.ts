import { RowId, YDatabaseField, YDoc, YjsDatabaseKey } from '@/application/types';
import { getCellData } from '@/application/database-yjs/const';
import { FieldType } from '@/application/database-yjs/database.type';
import { parseSelectOptionTypeOptions } from '@/application/database-yjs/fields';
import { Row } from '@/application/database-yjs/selector';

export function groupByField (rows: Row[], rowMetas: Record<RowId, YDoc>, field: YDatabaseField) {
  const fieldType = Number(field.get(YjsDatabaseKey.type));
  const isSelectOptionField = [FieldType.SingleSelect, FieldType.MultiSelect].includes(fieldType);

  if (isSelectOptionField) {
    return groupBySelectOption(rows, rowMetas, field);
  }

  if (fieldType === FieldType.Checkbox) {
    return groupByCheckbox(rows, rowMetas, field);
  }

  return;
}

export function groupByCheckbox (rows: Row[], rowMetas: Record<RowId, YDoc>, field: YDatabaseField) {
  const fieldId = field.get(YjsDatabaseKey.id);
  const result = new Map<string, Row[]>();

  rows.forEach((row) => {
    const cellData = getCellData(row.id, fieldId, rowMetas);

    const groupName = cellData === 'Yes' ? 'Yes' : 'No';
    const group = result.get(groupName) ?? [];

    group.push(row);
    result.set(groupName, group);
  });
  return result;
}

export function groupBySelectOption (rows: Row[], rowMetas: Record<RowId, YDoc>, field: YDatabaseField) {
  const fieldId = field.get(YjsDatabaseKey.id);
  const result = new Map<string, Row[]>();
  const typeOption = parseSelectOptionTypeOptions(field);

  if (!typeOption) {
    return;
  }

  if (typeOption.options.length === 0) {
    result.set(fieldId, rows);
    return result;
  }

  rows.forEach((row) => {
    const cellData = getCellData(row.id, fieldId, rowMetas);

    const selectedIds = (cellData as string)?.split(',') ?? [];

    if (selectedIds.length === 0) {
      const group = result.get(fieldId) ?? [];

      group.push(row);
      result.set(fieldId, group);
      return;
    }

    selectedIds.forEach((id) => {
      const option = typeOption.options.find((option) => option.id === id);
      const groupName = option?.id ?? fieldId;
      const group = result.get(groupName) ?? [];

      group.push(row);
      result.set(groupName, group);
    });
  });

  return result;
}
