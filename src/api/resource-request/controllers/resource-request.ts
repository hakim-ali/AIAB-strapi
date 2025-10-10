/**
 * resource-request controller
 */

import { factories } from '@strapi/strapi'

export default factories.createCoreController('api::resource-request.resource-request', {
    async create(ctx) {
        const { data } = ctx.request.body;
        const lastRequest = await strapi.db.query('api::resource-request.resource-request').findOne({
            where: {},
            select: ['ticketId'],
            orderBy: { ticketId: 'desc' },
        });

        const lastId = lastRequest?.ticketId || 0

        data.ticketId = lastId + 1;

        return await super.create(ctx);
    }
});
