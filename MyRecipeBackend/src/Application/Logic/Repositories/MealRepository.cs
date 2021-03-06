﻿using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Interfaces.Repositories;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Logic.Repositories
{
    public class MealRepository : EntityRepository<Meal>, IMealRepository
    {
        public MealRepository(IApplicationDbContext dbContext) : base(dbContext)
        {
        }

        /// <summary>
        ///     Adds a new Meal and adds the vote for the initiator
        /// </summary>
        /// <param name="proposeModel"></param>
        /// <returns></returns>
        public async Task ProposeMealAsync(Meal mealModel)
        {
            await _dbContext.Meals.AddAsync(mealModel);
        }

        public async Task VoteMealAsync(string userId, VoteEnum vote, Guid mealId)
        {
            var existing = await _dbContext.MealVotes
                .Where(mv => mv.MealId == mealId)
                .Where(mv => mv.UserId == userId)
                .SingleOrDefaultAsync();

            if (existing is not null)
            {
                //withdraw vote
                if (vote == existing.Vote)
                {
                    _dbContext.MealVotes.Remove(existing);
                    return;
                }

                //If different, then apply change
                existing.Vote = vote;
                return;
            }

            await _dbContext.MealVotes.AddAsync(new MealVote
            {
                MealId = mealId,
                UserId = userId,
                Vote = vote
            });
        }

        public async Task<Meal[]> GetMealsWithRecipeAndInitiatorAsync(Guid groupId, bool? isAccepted)
        {
            var query = _dbContext.Meals
                .Include(m => m.Initiator)
                .Include(m => m.Recipe)
                .ThenInclude(r => r.Ingredients)
                .Include(m => m.MealVotes)
                .ThenInclude<Meal, MealVote, ApplicationUser>(v => v.User)
                .Where(m => m.GroupId == groupId);

            if (isAccepted != null) query = query.Where(m => m.Accepted == isAccepted.Value);

            query = query.OrderBy(m => m.DateTime);

            return await query.ToArrayAsync();
        }

        public async Task<Meal> GetMealByIdAsync(Guid groupId, Guid id)
        {
            return await _dbContext.Meals
                .Include(m => m.Initiator)
                .Include(m => m.Recipe)
                .ThenInclude(r => r.Ingredients)
                .Include(m => m.MealVotes)
                .ThenInclude<Meal, MealVote, ApplicationUser>(v => v.User)
                .Where(m => m.GroupId == groupId && m.Id == id)
                .SingleOrDefaultAsync();
        }

        public Task<bool> UserHasAlreadyVotedAsync(MealVote mealVote)
        {
            return _dbContext.MealVotes.AnyAsync(m => m.UserId == mealVote.User.Id && m.MealId == mealVote.Meal.Id);
        }
    }
}