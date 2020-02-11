import { IIngredient } from './IIngredient';
import { IStep } from './IStep';

export interface IRecipe {
    id: number;
    name: string;
    ownerId: number;
    ingredients: IIngredient[];
    steps: IStep[];
    estimatedTime: number;
    estimatedCalories: number;

}